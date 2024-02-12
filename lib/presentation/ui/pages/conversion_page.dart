import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_states.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_bloc.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
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
import 'package:convertouch/presentation/ui/scaffold_widgets/refresh_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/secondary_app_bar.dart';
import 'package:convertouch/presentation/ui/style/color/color_set.dart';
import 'package:convertouch/presentation/ui/style/color/color_state_variation.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchConversionPage extends StatelessWidget {
  const ConvertouchConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      ButtonColorSet floatingButtonColor =
          conversionPageFloatingButtonColors[appState.theme]!;

      ColorStateVariation<BaseColorSet> unitGroupInAppBarColor =
          unitGroupItemInAppBarColors[appState.theme]!;

      return conversionBlocBuilder((pageState) {
        final conversion = pageState.conversion;

        return MultiBlocListener(
          listeners: [
            BlocListener<UnitsBloc, UnitsState>(
              listener: (_, unitsState) {
                if (unitsState is UnitsFetched &&
                    unitsState.rebuildConversion) {
                  BlocProvider.of<ConversionBloc>(context).add(
                    BuildConversion(
                      conversionParams: InputConversionModel(
                        unitGroup: conversion.unitGroup,
                        sourceConversionItem: conversion.sourceConversionItem,
                        targetUnits: conversion.targetConversionItems
                            .map((item) => item.unit)
                            .toList(),
                      ),
                      modifiedUnit: unitsState.modifiedUnit,
                      removedUnitIds: unitsState.removedIds,
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
            BlocListener<RefreshingJobsBloc, RefreshingJobsState>(
              listener: (_, state) {
                if (state is RefreshingJobsFetched &&
                    state.rebuiltConversion != null) {
                  BlocProvider.of<ConversionBloc>(context).add(
                    ShowNewConversionAfterRefresh(
                      newConversion: state.rebuiltConversion!,
                    ),
                  );
                } else if (state is RefreshingJobsNotificationState) {
                  showSnackBar(
                    context,
                    exception: state.exception,
                    theme: appState.theme,
                  );
                }
              },
            ),
            BlocListener<ConversionBloc, ConversionState>(
              listener: (_, state) {
                if (state is ConversionNotificationState) {
                  showSnackBar(
                    context,
                    exception: state.exception,
                    theme: appState.theme,
                  );
                }
              },
            ),
          ],
          child: ConvertouchPage(
            title: "Conversion",
            secondaryAppBar: conversion.unitGroup != null
                ? SecondaryAppBar(
                    theme: appState.theme,
                    color: Colors.transparent,
                    child: ConvertouchMenuItem(
                      conversion.unitGroup!,
                      customColors: unitGroupInAppBarColor,
                      onTap: () {
                        BlocProvider.of<UnitGroupsBlocForConversion>(context)
                            .add(
                          FetchUnitGroupsForChangeInConversion(
                            currentUnitGroupInConversion: conversion.unitGroup!,
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
                : null,
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
                const ConvertouchRefreshFloatingButton(),
                ConvertouchFloatingActionButton.adding(
                  onClick: () {
                    if (conversion.unitGroup == null) {
                      BlocProvider.of<UnitGroupsBlocForConversion>(context).add(
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
                  colorSet: floatingButtonColor,
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
