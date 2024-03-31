import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/refreshing_jobs_page/refreshing_jobs_states.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:convertouch/presentation/ui/pages/templates/basic_page.dart';
import 'package:convertouch/presentation/ui/style/color/color_scheme.dart';
import 'package:convertouch/presentation/ui/style/color/colors.dart';
import 'package:convertouch/presentation/ui/widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/conversion_items_view.dart';
import 'package:convertouch/presentation/ui/widgets/items_view/item/menu_item.dart';
import 'package:convertouch/presentation/ui/widgets/refresh_button.dart';
import 'package:convertouch/presentation/ui/widgets/secondary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchConversionPage extends StatelessWidget {
  const ConvertouchConversionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBlocBuilder((appState) {
      PageColorScheme pageColorScheme = pageColors[appState.theme]!;

      ConvertouchColorScheme floatingButtonColor =
          conversionPageFloatingButtonColors[appState.theme]!;

      ListItemColorScheme unitGroupInAppBarColor =
          unitGroupItemInAppBarColors[appState.theme]!;

      return conversionBlocBuilder((pageState) {
        final conversion = pageState.conversion;

        Widget addingButton() {
          return ConvertouchFloatingActionButton.adding(
            onClick: () {
              if (conversion.unitGroup == null) {
                BlocProvider.of<UnitGroupsBlocForConversion>(context).add(
                  const FetchUnitGroupsForFirstAddingToConversion(
                    searchString: null,
                  ),
                );
              } else {
                BlocProvider.of<UnitsBlocForConversion>(context).add(
                  FetchUnitsToMarkForConversionFirstTime(
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
              }
            },
            colorScheme: floatingButtonColor,
          );
        }

        return MultiBlocListener(
          listeners: [
            unitsBlocListener([
              StateHandler<UnitsFetched>((state) {
                if (state.rebuildConversion) {
                  BlocProvider.of<ConversionBloc>(context).add(
                    BuildConversion(
                      conversionParams: InputConversionModel(
                        unitGroup: conversion.unitGroup,
                        sourceConversionItem: conversion.sourceConversionItem,
                        targetUnits: conversion.targetConversionItems
                            .map((item) => item.unit)
                            .toList(),
                      ),
                      modifiedUnit: state.modifiedUnit,
                      removedUnitIds: state.removedIds,
                    ),
                  );
                }
              }),
            ]),
            unitGroupsBlocListener([
              StateHandler<UnitGroupsFetched>((state) {
                if (state.rebuildConversion) {
                  BlocProvider.of<ConversionBloc>(context).add(
                    BuildConversion(
                      conversionParams: InputConversionModel(
                        unitGroup: pageState.conversion.unitGroup,
                        sourceConversionItem:
                            pageState.conversion.sourceConversionItem,
                        targetUnits: pageState.conversion.targetConversionItems
                            .map((item) => item.unit)
                            .toList(),
                      ),
                      modifiedUnitGroup: state.modifiedUnitGroup,
                      removedUnitGroupIds: state.removedIds,
                    ),
                  );
                }
              }),
            ]),
            refreshingJobsBlocListener([
              StateHandler<RefreshingJobsFetched>((state) {
                if (state.rebuiltConversion != null) {
                  BlocProvider.of<ConversionBloc>(context).add(
                    ShowNewConversionAfterRefresh(
                      newConversion: state.rebuiltConversion!,
                    ),
                  );
                }
              }),
            ]),
          ],
          child: ConvertouchPage(
            title: "Conversion",
            secondaryAppBar: conversion.unitGroup != null
                ? SecondaryAppBar(
                    theme: appState.theme,
                    color: pageColorScheme.appBar.background.regular,
                    padding: const EdgeInsets.only(
                      left: 7,
                      top: 0,
                      right: 7,
                      bottom: 7,
                    ),
                    child: ConvertouchMenuItem(
                      conversion.unitGroup!,
                      height: 48,
                      customColors: unitGroupInAppBarColor,
                      onTap: () {
                        BlocProvider.of<UnitGroupsBlocForConversion>(context)
                            .add(
                          FetchUnitGroupsForChangeInConversion(
                            currentUnitGroupInConversion: conversion.unitGroup!,
                            searchString: null,
                          ),
                        );
                      },
                      itemsViewMode: ItemsViewMode.list,
                      theme: appState.theme,
                    ),
                  )
                : null,
            body: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ConvertouchConversionItemsView(
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
                      id: item.unit.id!,
                    ),
                  );
                },
                noItemsView: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "No Conversion Items Added",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: unitPageEmptyViewColor[appState.theme]!
                                .foreground
                                .regular,
                          ),
                        ),
                      ),
                      addingButton(),
                    ],
                  ),
                ),
                theme: appState.theme,
              ),
            ),
            floatingActionButton: Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                const ConvertouchRefreshFloatingButton(),
                conversion.targetConversionItems.isNotEmpty
                    ? addingButton()
                    : empty(),
              ],
            ),
          ),
        );
      });
    });
  }
}
