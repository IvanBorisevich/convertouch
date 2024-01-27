import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_control/refreshing_jobs_control_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/items_view/conversion_items_view.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/progress_button.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchConversionPage extends StatelessWidget {
  const ConvertouchConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ButtonColorVariation floatingButtonColor =
          conversionPageFloatingButtonColors[appState.theme]!;

      ButtonColor refreshButtonColor =
          refreshingJobItemsColors[appState.theme]!.refreshButton;

      ScaffoldColorVariation scaffoldColor =
          scaffoldColors[appState.theme]!.regular;

      return conversionBlocBuilder((pageState) {
        final conversion = pageState.conversion;

        return MultiBlocListener(
          listeners: [
            BlocListener<UnitsBloc, UnitsState>(
              listener: (_, unitsState) {
                if (unitsState is UnitsFetched &&
                    unitsState.removedIds.isNotEmpty &&
                    unitsState.unitGroup == conversion.unitGroup) {
                  BlocProvider.of<ConversionBloc>(context).add(
                    BuildConversion(
                      conversionParams: InputConversionModel(
                        unitGroup: unitsState.unitGroup,
                        sourceConversionItem: conversion.sourceConversionItem,
                        targetUnits: conversion.targetConversionItems
                            .map((item) => item.unit)
                            .whereNot((unit) =>
                                unitsState.removedIds.contains(unit.id))
                            .toList(),
                      ),
                    ),
                  );
                }
              },
            ),
            BlocListener<UnitGroupsBloc, UnitGroupsState>(
              listener: (_, state) {
                if (state is UnitGroupsFetched &&
                    state.removedIds.isNotEmpty &&
                    conversion.unitGroup != null &&
                    state.removedIds.contains(conversion.unitGroup!.id)) {
                  BlocProvider.of<ConversionBloc>(context).add(
                    const BuildConversion(
                      conversionParams: InputConversionModel(
                        unitGroup: null,
                        sourceConversionItem: null,
                      ),
                    ),
                  );
                }
              },
            ),
            BlocListener<RefreshingJobsControlBloc, RefreshingJobsControlState>(
              listener: (_, state) {
                if (state is RefreshingJobsProgressUpdated) {
                  for (var job in state.jobsInProgress.values) {
                    job.progressController?.stream.lastWhere(
                      (jobResult) {
                        return jobResult.progressPercent == 1.0;
                      },
                    ).then(
                      (jobResult) {
                        log("Finalizing the job '${job.name}'");
                        BlocProvider.of<RefreshingJobsControlBloc>(context).add(
                          FinishJob(
                            job: job,
                            jobsInProgress: state.jobsInProgress,
                          ),
                        );
                        if (jobResult.rebuiltConversion != null) {
                          BlocProvider.of<ConversionBloc>(context).add(
                            ShowNewConversionAfterRefresh(
                              newConversion: jobResult.rebuiltConversion!,
                              job: job,
                            ),
                          );
                        }
                      },
                    );
                  }
                }
              },
            ),
            BlocListener<ConversionBloc, ConversionState>(
              listener: (_, state) {
                if (state is ConversionNotificationState) {
                  showSnackBar(
                    context,
                    message: state.message,
                    contentColor: scaffoldColor.backgroundColor,
                  );
                }
              },
            ),
          ],
          child: refreshingJobsControlBlocBuilder((jobsControlState) {
            final jobInProgress =
                jobsControlState.jobsInProgress[pageState.job?.id];

            return ConvertouchPage(
              appState: appState,
              title: "Conversion",
              secondaryAppBar: conversion.unitGroup != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: ConvertouchMenuItem(
                        conversion.unitGroup!,
                        customColors:
                            appBarUnitGroupItemColors[appState.theme]!,
                        onTap: () {
                          BlocProvider.of<UnitGroupsBlocForConversion>(context)
                              .add(
                            FetchUnitGroupsForChangeInConversion(
                              currentUnitGroupInConversion:
                                  conversion.unitGroup!,
                              searchString: null,
                            ),
                          );
                          Navigator.of(context).pushNamed(
                            PageName.unitGroupsPageForConversion.name,
                          );
                        },
                        itemsViewMode: ItemsViewMode.list,
                        theme: appState.theme,
                      ),
                    )
                  : empty(),
              secondaryAppBarHeight: conversion.unitGroup != null ? 60 : 0,
              secondaryAppBarColor: Colors.transparent,
              body: ConvertouchConversionItemsView(
                conversion.targetConversionItems,
                onItemTap: (item) {
                  BlocProvider.of<UnitsBlocForConversion>(context).add(
                    FetchUnitsForChangeInConversion(
                      currentSelectedUnit: item.unit,
                      unitGroup: conversion.unitGroup!,
                      unitsInConversion: conversion.targetConversionItems
                          .map((convItem) => convItem.unit)
                          .toList(),
                      currentSourceConversionItem:
                          conversion.sourceConversionItem,
                      searchString: null,
                    ),
                  );
                  Navigator.of(context).pushNamed(
                    PageName.unitsPageForConversion.name,
                  );
                },
                onItemValueChanged: (item, value) {
                  BlocProvider.of<ConversionBloc>(context).add(
                    RebuildConversionOnValueChange(
                      conversionParams: InputConversionModel(
                        sourceConversionItem: ConversionItemModel.fromStrValue(
                          unit: item.unit,
                          strValue: value,
                        ),
                        targetUnits: conversion.targetConversionItems
                            .map((item) => item.unit)
                            .toList(),
                        unitGroup: conversion.unitGroup,
                      ),
                    ),
                  );
                },
                onItemRemove: (item) {
                  BlocProvider.of<ConversionBloc>(context).add(
                    RemoveConversionItem(
                      itemUnitId: item.unit.id!,
                      conversionItems: conversion.targetConversionItems,
                      unitGroupInConversion: conversion.unitGroup,
                    ),
                  );
                },
                theme: appState.theme,
              ),
              floatingActionButton: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  ConvertouchProgressButton(
                    buttonWidget: ConvertouchFloatingActionButton(
                      visible: pageState.showRefreshButton,
                      onClick: () {
                        BlocProvider.of<RefreshingJobsControlBloc>(context).add(
                          ExecuteJob(
                            job: pageState.job!,
                            jobsInProgress: jobsControlState.jobsInProgress,
                            conversionToBeRebuilt: pageState.conversion,
                          ),
                        );
                      },
                      icon: Icons.refresh_rounded,
                      background: const Color(0xFF639D82),
                      foreground: floatingButtonColor.foreground,
                    ),
                    radius: 28,
                    onProgressIndicatorClick: () {
                      BlocProvider.of<RefreshingJobsControlBloc>(context).add(
                        StopJob(
                          job: pageState.job!,
                          jobsInProgress: jobsControlState.jobsInProgress,
                        ),
                      );
                    },
                    onOngoingProgressIndicatorClick: () {
                      BlocProvider.of<RefreshingJobsControlBloc>(context).add(
                        StopJob(
                          job: pageState.job!,
                          jobsInProgress: jobsControlState.jobsInProgress,
                        ),
                      );
                    },
                    margin: const EdgeInsets.only(right: 7),
                    progressStream: jobInProgress?.progressController?.stream,
                    progressIndicatorColor:
                        refreshButtonColor.regular.foreground,
                  ),
                  ConvertouchFloatingActionButton.adding(
                    onClick: () {
                      if (conversion.unitGroup == null) {
                        BlocProvider.of<UnitGroupsBlocForConversion>(context)
                            .add(
                          const FetchUnitGroupsForFirstAddingToConversion(
                            searchString: null,
                          ),
                        );
                        Navigator.of(context).pushNamed(
                          PageName.unitGroupsPageForConversion.name,
                        );
                      } else {
                        BlocProvider.of<UnitsBlocForConversion>(context).add(
                          FetchUnitsToMarkForConversion(
                            unitGroup: conversion.unitGroup!,
                            unitsAlreadyMarkedForConversion: conversion
                                .targetConversionItems
                                .map((unitValue) => unitValue.unit)
                                .toList(),
                            currentSourceConversionItem:
                                conversion.sourceConversionItem,
                            searchString: null,
                          ),
                        );
                        Navigator.of(context).pushNamed(
                          PageName.unitsPageForConversion.name,
                        );
                      }
                    },
                    background: floatingButtonColor.background,
                    foreground: floatingButtonColor.foreground,
                  ),
                ],
              ),
            );
          }),
        );
      });
    });
  }
}
