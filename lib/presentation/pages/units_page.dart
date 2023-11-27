import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/units_page/units_states.dart';
import 'package:convertouch/presentation/pages/abstract_page.dart';
import 'package:convertouch/presentation/pages/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/pages/scaffold/search_bar.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/color.dart';
import 'package:convertouch/presentation/pages/style/model/color_variation.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitsPage extends ConvertouchPage {
  const ConvertouchUnitsPage({super.key});

  @override
  Widget buildBody(
    BuildContext context,
    ConvertouchCommonStateBuilt commonState,
  ) {
    return unitsBloc((pageState) {
      ScaffoldColorVariation scaffoldColor =
          scaffoldColors[commonState.theme]!.regular;

      List<int> unitIdsSelectedForConversion = [];
      UnitModel? selectedEquivalentUnit;
      bool showMarkedItems = false;

      if (pageState is UnitsFetchedForEquivalentUnitSelection) {
        selectedEquivalentUnit = pageState.selectedEquivalentUnit;
      } else if (pageState is UnitsFetchedForConversion) {
        unitIdsSelectedForConversion = pageState.unitIdsSelectedForConversion;
        showMarkedItems = true;
      }

      return Column(
        children: [
          Container(
            height: 53,
            decoration: BoxDecoration(
              color: scaffoldColor.appBarColor,
            ),
            padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 7, 7),
            child: ConvertouchSearchBar(
              placeholder: "Search units...",
              theme: commonState.theme,
              iconViewMode: ItemsViewMode.list, //pageState.iconViewMode!,
              pageViewMode: ItemsViewMode.grid,
            ),
          ),
          Expanded(
            child: ConvertouchMenuItemsView(
              pageState.units,
              markedItemIds: unitIdsSelectedForConversion,
              showMarkedItems: showMarkedItems,
              selectedItemId: selectedEquivalentUnit?.id,
              showSelectedItem: selectedEquivalentUnit != null,
              markItemsOnTap:
                  pageState.runtimeType == UnitsFetchedForConversion,
              removalModeAllowed: pageState.runtimeType == UnitsFetched,
              onItemTap: (item) {
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
              commonState: commonState,
            ),
          ),
        ],
      );
    });
  }

  @override
  void onStart(BuildContext context) {
  }

  @override
  Widget buildAppBar(
    BuildContext context,
    ConvertouchCommonStateBuilt commonState,
  ) {
    return unitsBloc((pageState) {
      String pageTitle;
      switch (pageState.runtimeType) {
        case UnitsFetchedForConversion:
          pageTitle = "Select Units For Conversion";
          break;
        case UnitsFetchedForEquivalentUnitSelection:
          pageTitle = "Select Equivalent Unit";
          break;
        default:
          pageTitle = "Units";
          break;
      }

      return buildAppBarForState(
        context,
        commonState,
        pageTitle: pageTitle,
      );
    });
  }

  @override
  Widget buildFloatingActionButton(
    BuildContext context,
    ConvertouchCommonStateBuilt commonState,
  ) {
    return unitGroupsBloc((pageState) {
      ConvertouchScaffoldColor commonColor = scaffoldColors[commonState.theme]!;
      FloatingButtonColorVariation removalButtonColor =
      removalFloatingButtonColors[commonState.theme]!;

      return Visibility(
        visible: pageState.floatingButtonVisible,
        child: SizedBox(
          height: 70,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              FittedBox(
                child: commonState.removalMode
                    ? floatingActionButton(
                  iconData: Icons.delete_outline_rounded,
                  onClick: () {},
                  color:
                  unitsPageFloatingButtonColors[commonState.theme]!,
                )
                    : floatingActionButton(
                  iconData: Icons.add,
                  onClick: () {
                    // BlocProvider.of<UnitGroupsBloc>(context).add(
                    //   PrepareUnitGroupCreation(),
                    // );
                  },
                  color:
                  unitsPageFloatingButtonColors[commonState.theme]!,
                ),
              ),
              commonState.removalMode
                  ? itemsRemovalCounter(
                itemsCount: commonState.selectedItemIdsForRemoval.length,
                backgroundColor: removalButtonColor.background,
                foregroundColor: removalButtonColor.foreground,
                borderColor: commonColor.regular.backgroundColor,
              )
                  : empty(),
            ],
          ),
        ),
      );
    });
  }
}
