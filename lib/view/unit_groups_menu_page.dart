import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/unit_groups_menu_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/states/unit_groups_menu_states.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:convertouch/view/items_menu/items_menu_view.dart';
import 'package:convertouch/view/scaffold/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsMenuPage extends StatelessWidget {
  const ConvertouchUnitGroupsMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UnitsMenuBloc, UnitsMenuState>(
        listener: (_, unitsMenuState) {
          if (unitsMenuState is UnitsFetched) {
            Navigator.of(context).pushNamed(unitsPageId);
          }
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: BlocBuilder<UnitsMenuBloc, UnitsMenuState>(
                  buildWhen: (prev, next) {
                return prev != next && next is UnitsSelected;
              }, builder: (_, unitsMenuState) {
                bool isBackButtonActive = unitsMenuState is UnitsSelected &&
                    unitsMenuState.selectedUnits.isNotEmpty;
                return IconButton(
                  icon: Icon(
                    isBackButtonActive ? Icons.arrow_back_rounded : Icons.menu,
                    color: const Color(0xFF426F99),
                  ),
                  onPressed: () {
                    if (isBackButtonActive) {
                      Navigator.of(context).pop();
                    }
                  },
                );
              }),
              centerTitle: true,
              title: const Text(
                "Unit Groups",
                style: TextStyle(
                    color: Color(0xFF426F99),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              backgroundColor: const Color(0xFFDEE9FF),
              elevation: 0,
            ),
            body: Column(
              children: [
                const ConvertouchSearchBar(
                    searchBarPlaceholder: "Search unit groups..."
                ),
                Expanded(
                    child: BlocBuilder<UnitGroupsMenuBloc, UnitGroupsMenuState>(
                        buildWhen: (prev, next) {
                  return prev != next && next is UnitGroupsFetched;
                }, builder: (_, unitGroupsMenuState) {
                  List<UnitGroupModel> unitGroups =
                      unitGroupsMenuState is UnitGroupsFetched
                          ? unitGroupsMenuState.unitGroups
                          : [];
                  return BlocBuilder<ItemsMenuViewBloc, ItemsMenuViewState>(
                      builder: (_, itemsMenuViewState) {
                    return ConvertouchItemsMenuView(
                        unitGroups, itemsMenuViewState.itemsMenuView
                    );
                  });
                })),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(unitGroupCreationPageId);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ));
  }
}
