import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc_for_conversion.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:convertouch/presentation/ui/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/search_bar.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsPage extends StatelessWidget {
  const ConvertouchUnitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return appBloc((appState) {
      return unitsBloc((pageState) {
        return unitsBlocForConversion((pageStateForConversion) {
          ScaffoldColorVariation scaffoldColor =
              scaffoldColors[appState.theme]!.regular;
          FloatingButtonColorVariation floatingButtonColor =
              unitsPageFloatingButtonColors[appState.theme]!;

          String pageTitle = "Units";
          List<int>? unitIdsMarkedForConversion;
          List<UnitModel>? unitsMarkedForConversion;
          // UnitModel? selectedEquivalentUnit;
          bool showMarkedItems = false;
          bool allowUnitsToBeAddedToConversion = false;
          bool removalModeAllowed = true;
          bool markItemsOnTap = false;
          bool floatingButtonVisible = true;

          if (appState.activeNavbarItem == BottomNavbarItem.home) {
            removalModeAllowed = false;
            floatingButtonVisible = false;

            if (pageStateForConversion is UnitsFetchedForConversion) {
              pageTitle = "Add Units To Convert";
              unitIdsMarkedForConversion =
                  pageStateForConversion.unitIdsMarkedForConversion;
              unitsMarkedForConversion =
                  pageStateForConversion.unitsMarkedForConversion;
              showMarkedItems = true;
              allowUnitsToBeAddedToConversion =
                  pageStateForConversion.allowUnitsToBeAddedToConversion;
              markItemsOnTap = true;
            }
          }

          return ConvertouchPage(
            appState: appState,
            title: pageTitle,
            appBarRightWidgets: showMarkedItems
                ? [
                    IconButton(
                      icon: Icon(
                        Icons.check,
                        color: allowUnitsToBeAddedToConversion
                            ? scaffoldColor.appBarIconColor
                            : null,
                      ),
                      disabledColor: scaffoldColor.appBarIconColorDisabled,
                      onPressed: allowUnitsToBeAddedToConversion
                          ? () {
                              BlocProvider.of<UnitsConversionBloc>(context).add(
                                BuildConversion(
                                  unitGroup: pageState.unitGroup,
                                  units: unitsMarkedForConversion,
                                ),
                              );
                              Navigator.of(context).popUntil(
                                (route) => route.isFirst,
                              );
                            }
                          : null,
                    )
                  ]
                : null,
            secondaryAppBar: ConvertouchSearchBar(
              placeholder: "Search units...",
              theme: appState.theme,
              iconViewMode: ItemsViewMode.list,
              pageViewMode: ItemsViewMode.grid,
            ),
            body: ConvertouchMenuItemsView(
              pageState.units,
              markedItemIds: unitIdsMarkedForConversion,
              showMarkedItems: showMarkedItems,
              // selectedItemId: selectedEquivalentUnit?.id,
              // showSelectedItem: selectedEquivalentUnit != null,
              markItemsOnTap: markItemsOnTap,
              removalModeAllowed: removalModeAllowed,
              onItemTap: (item) {
                if (pageStateForConversion is UnitsFetchedForConversion) {
                  BlocProvider.of<UnitsBlocForConversion>(context).add(
                    FetchUnitsForConversion(
                      unitsAlreadyMarkedForConversion: unitsMarkedForConversion,
                      unitNewlyMarkedForConversion: item as UnitModel,
                    ),
                  );
                }
                // switch (action) {
                //   case ConvertouchAction.fetchUnitsToSelectForUnitCreation:
                //     BlocProvider.of<UnitCreationBloc>(context).add(
                //       PrepareUnitCreation(
                //         unitGroup: unitsFetched.unitGroup,
                //         equivalentUnit: item as UnitModel,
                //         markedUnits: unitsFetched.markedUnits,
                //         action: ConvertouchAction
                //             .updateEquivalentUnitForUnitCreation,
                //       ),
                //     );
                //     break;
                //   case ConvertouchAction.fetchUnitsToSelectForConversion:
                //     BlocProvider.of<UnitsConversionBloc>(context).add(
                //       InitializeConversion(
                //         inputUnit: item as UnitModel,
                //         inputValue: unitsFetched.inputValue,
                //         prevInputUnit: unitsFetched.selectedUnit,
                //         unitGroup: unitsFetched.unitGroup,
                //         conversionUnits: unitsFetched.markedUnits,
                //       ),
                //     );
                //     break;
                //   case ConvertouchAction.fetchUnitsToStartMark:
                //   case ConvertouchAction.fetchUnitsToContinueMark:
                //   default:
                //     BlocProvider.of<UnitsBloc>(context).add(
                //       FetchUnits(
                //         inputValue: unitsFetched.inputValue,
                //         unitGroupId: unitsFetched.unitGroup.id!,
                //         newMarkedUnit: item as UnitModel,
                //         markedUnits: unitsFetched.markedUnits,
                //         action: ConvertouchAction.fetchUnitsToContinueMark,
                //       ),
                //     );
                //     break;
                // }
              },
              theme: appState.theme,
            ),
            floatingActionButton: ConvertouchFloatingActionButton.adding(
              onClick: () {},
              visible: floatingButtonVisible,
              background: floatingButtonColor.background,
              foreground: floatingButtonColor.foreground,
            ),
          );
        });
      });
    });
  }
}
