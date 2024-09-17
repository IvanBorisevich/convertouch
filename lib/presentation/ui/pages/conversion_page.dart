import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
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

        return ConvertouchPage(
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
                      BlocProvider.of<UnitGroupsBlocForConversion>(context).add(
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
              valueType: conversion.unitGroup?.valueType ??
                  UnitGroupModel.defaultValueType,
              onUnitItemTap: (item) {
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
              onTextValueChanged: (item, value) {
                BlocProvider.of<ConversionBloc>(context).add(
                  EditConversionItemValue(
                    newValue: value,
                    unitId: item.unit.id!,
                  ),
                );
              },
              onItemRemoveTap: (item) {
                BlocProvider.of<ConversionBloc>(context).add(
                  RemoveConversionItems(
                    unitIds: [item.unit.id!],
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
        );
      });
    });
  }
}
