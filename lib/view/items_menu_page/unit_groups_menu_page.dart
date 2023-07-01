import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/items_menu_view.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/unit_groups_menu_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/states/unit_groups_menu_states.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:convertouch/view/items_menu_page/menu_view/items_grid.dart';
import 'package:convertouch/view/items_menu_page/menu_view/items_list.dart';
import 'package:convertouch/view/scaffold/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitGroupsMenuPage extends StatelessWidget {
  const ConvertouchUnitGroupsMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UnitsMenuFetchBloc, UnitsMenuState>(
        listener: (_, unitsMenuState) {
          if (unitsMenuState is UnitsFetched) {
            Navigator.pushNamed(context, unitsPageId);
          }
        },
        child: BlocBuilder<UnitGroupsMenuFetchBloc, UnitGroupsFetched>(
            builder: (_, unitGroupsFetched) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: BlocBuilder<UnitsMenuSelectBloc, UnitsSelected>(
                    builder: (_, unitsSelected) {
                  return IconButton(
                    icon: Icon(
                      unitsSelected.selectedUnits.isNotEmpty
                          ? Icons.arrow_back_rounded
                          : Icons.menu,
                      color: const Color(0xFF426F99),
                    ),
                    onPressed: () {
                      if (unitsSelected.selectedUnits.isNotEmpty) {
                        Navigator.of(context).pop();
                      } else {

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
                      searchBarPlaceholder: "Search unit groups..."),
                  Expanded(child:
                      BlocBuilder<ItemsMenuViewBloc, ItemsMenuViewState>(
                          builder: (_, itemsMenuViewState) {
                    return LayoutBuilder(builder: (context, constraints) {
                      switch (itemsMenuViewState.itemsMenuView) {
                        case ItemsMenuView.grid:
                          return ConvertouchItemsGrid(
                              unitGroupsFetched.unitGroups);
                        case ItemsMenuView.list:
                          return ConvertouchItemsList(
                              unitGroupsFetched.unitGroups);
                      }
                    });
                  })),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          );
        }));
  }
}
