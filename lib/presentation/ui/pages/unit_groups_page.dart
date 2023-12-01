import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/presentation/bloc/base_bloc.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:convertouch/presentation/bloc/bloc_wrappers.dart';
import 'package:convertouch/presentation/bloc/unit_creation_page/unit_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_group_creation_page/unit_group_creation_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_bloc.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_events.dart';
import 'package:convertouch/presentation/bloc/unit_groups_page/unit_groups_states.dart';
import 'package:convertouch/presentation/bloc/units_page/units_bloc.dart';
import 'package:convertouch/presentation/bloc/units_page/units_events.dart';
import 'package:convertouch/presentation/ui/items_view/menu_items_view.dart';
import 'package:convertouch/presentation/ui/pages/basic_page.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/floating_action_button.dart';
import 'package:convertouch/presentation/ui/scaffold_widgets/search_bar.dart';
import 'package:convertouch/presentation/ui/style/colors.dart';
import 'package:convertouch/presentation/ui/style/model/color.dart';
import 'package:convertouch/presentation/ui/style/model/color_variation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsPage extends StatelessWidget {
  const ConvertouchUnitGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return unitGroupsBloc((pageState) {
      return globalBloc((globalState) {
        FloatingButtonColorVariation floatingButtonColor =
          unitGroupsPageFloatingButtonColors[globalState.theme]!;

        UnitGroupModel? selectedGroup;
        if (pageState is UnitGroupsFetchedForUnitCreation) {
          selectedGroup = pageState.unitGroupInUnitCreation;
        } else if (pageState is UnitGroupsFetchedForConversion) {
          selectedGroup = pageState.unitGroupInConversion;
        }
        
        return ConvertouchPage(
          globalState: globalState,
          title: "Unit Groups",
          secondaryAppBar: ConvertouchSearchBar(
            placeholder: "Search unit groups...",
            theme: globalState.theme,
            iconViewMode: ItemsViewMode.list,
            pageViewMode: ItemsViewMode.grid,
          ),
          body: ConvertouchMenuItemsView(
            pageState.unitGroups,
            // selectedItemId: selectedGroup?.id,
            // showSelectedItem: selectedGroup != null,
            removalModeAllowed: pageState.runtimeType == UnitGroupsFetched,
            onItemTap: (item) {
              BlocProvider.of<ConvertouchCommonBloc>(context).add(
                const ConvertouchCommonEvent(
                  targetPageId: unitsPageId,
                  currentState: UnitGroupsFetched,
                  // startPageIndex: commonState.startPageIndex,
                ),
              );

              if (pageState.runtimeType == UnitGroupsFetched) {
                BlocProvider.of<UnitsBloc>(context).add(
                  FetchUnitsOfGroup(
                    unitGroupId: item.id!,
                  ),
                );
              } else if (pageState.runtimeType ==
                  UnitGroupsFetchedForConversion) {
              } else if (pageState.runtimeType ==
                  UnitGroupsFetchedForUnitCreation) {
                // BlocProvider.of<UnitCreationBloc>(context).add(
                //   PrepareUnitCreation(
                //     unitGroup: item as UnitGroupModel,
                //   ),
                // );
              }
            },
            commonState: globalState,
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
            background: floatingButtonColor.background,
            foreground: floatingButtonColor.foreground,
          ),
        );
      });
    });
  }
}
