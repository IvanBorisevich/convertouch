import 'package:convertouch/model/items_menu_view.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:convertouch/view/items_menu_page/menu_view/items_grid.dart';
import 'package:convertouch/view/items_menu_page/menu_view/items_list.dart';
import 'package:convertouch/view/scaffold/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsMenuPage extends StatelessWidget {
  const ConvertouchUnitsMenuPage({super.key});

  static const int _selectedUnitsMinNumForConversion = 2;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitsMenuFetchBloc, UnitsMenuState>(
        buildWhen: (prev, next) {
      return prev != next && next is UnitsFetched;
    }, builder: (_, unitsMenuState) {
      UnitsFetched unitsFetched = unitsMenuState as UnitsFetched;
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF426F99),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            title: const Text(
              "Units",
              style: TextStyle(
                  color: Color(0xFF426F99),
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: const Color(0xFFDEE9FF),
            elevation: 0,
            actions: [
              BlocBuilder<UnitsMenuSelectBloc, UnitsSelected>(
                  builder: (_, unitsSelected) {
                return IconButton(
                  icon: const Icon(
                    Icons.check,
                    color: Color(0xFF426F99),
                  ),
                  disabledColor: const Color(0xFF5E92C2),
                  onPressed: unitsSelected.selectedUnits.length >=
                          _selectedUnitsMinNumForConversion
                      ? () {}
                      : null,
                );
              }),
            ],
          ),
          body: Column(
            children: [
              const ConvertouchSearchBar(
                  searchBarPlaceholder: "Search units..."),
              Expanded(child:
                  BlocBuilder<ItemsMenuViewBloc, ItemsMenuViewState>(
                      builder: (_, itemsMenuViewState) {
                return LayoutBuilder(builder: (context, constraints) {
                  switch (itemsMenuViewState.itemsMenuView) {
                    case ItemsMenuView.grid:
                      return ConvertouchItemsGrid(unitsFetched.units);
                    case ItemsMenuView.list:
                      return ConvertouchItemsList(unitsFetched.units);
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
    });
  }
}
