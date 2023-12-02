import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/search_bar.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPage extends StatelessWidget {
  const ConvertouchUnitGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return unitGroupsBloc((pageState) {
      return appBloc((appState) {
        FloatingButtonColorVariation floatingButtonColor =
            unitGroupsPageFloatingButtonColors[appState.theme]!;

        UnitGroupModel? selectedGroup;
        String pageTitle = "Unit Groups";
        bool showSelectedItem = false;
        bool removalModeAllowed = true;

        if (appState.activeNavbarItem == BottomNavbarItem.home) {
          showSelectedItem = true;
          removalModeAllowed = false;

          if (pageState is UnitGroupsFetchedForUnitCreation) {
            pageTitle = "Select Group Of New Unit";
            selectedGroup = pageState.unitGroupInUnitCreation;
          } else if (pageState is UnitGroupsFetchedToChangeOneInConversion) {
            pageTitle = "Change Group In Conversion";
            selectedGroup = pageState.unitGroupInConversion;
          } else if (pageState is UnitGroupsFetchedToFetchUnitsForConversion) {
            pageTitle = "Select Group";
          }
        }

        return ConvertouchPage(
          appState: appState,
          title: pageTitle,
          secondaryAppBar: ConvertouchSearchBar(
            placeholder: "Search unit groups...",
            theme: appState.theme,
            iconViewMode: ItemsViewMode.list,
            pageViewMode: ItemsViewMode.grid,
          ),
          body: ConvertouchMenuItemsView(
            pageState.unitGroups,
            selectedItemId: selectedGroup?.id,
            showSelectedItem: showSelectedItem,
            removalModeAllowed: removalModeAllowed,
            onItemTap: (item) {
              switch (pageState.runtimeType) {
                case UnitGroupsFetched:
                  BlocProvider.of<UnitsBloc>(context).add(
                    FetchUnits(unitGroup: item as UnitGroupModel),
                  );
                  Navigator.of(context).pushNamed(unitsPageId);
                  break;
                case UnitGroupsFetchedToFetchUnitsForConversion:
                  BlocProvider.of<UnitsBloc>(context).add(
                    FetchUnitsForConversion(
                      unitGroup: item as UnitGroupModel,
                    ),
                  );
                  Navigator.of(context).pushNamed(unitsPageId);
                  break;
                case UnitGroupsFetchedToChangeOneInConversion:
                  BlocProvider.of<UnitsConversionBloc>(context).add(
                    BuildConversion(unitGroup: item as UnitGroupModel),
                  );
                  Navigator.of(context).pop();
                  break;
                case UnitGroupsFetchedForUnitCreation:
                  // BlocProvider.of<UnitCreationBloc>(context).add(
                  //   PrepareUnitCreation(
                  //     unitGroup: item as UnitGroupModel,
                  //   ),
                  // );
                  break;
              }
            },
            theme: appState.theme,
          ),
          floatingActionButton: ConvertouchFloatingActionButton.adding(
            onClick: () {
              // BlocProvider.of<UnitsBloc>(context).add(
              //   pageState.unitGroupInConversion != null
              //       ? FetchUnitsForConversion(
              //           unitGroupInConversion: pageState.unitGroupInConversion,
              //         )
              //       : FetchUnitGroupsForConversion(
              //           unitGroupInConversion: pageState.unitGroupInConversion,
              //         ),
              // );
            },
            visible: pageState.floatingButtonVisible,
            background: floatingButtonColor.background,
            foreground: floatingButtonColor.foreground,
          ),
        );
      });
    });
  }
}
