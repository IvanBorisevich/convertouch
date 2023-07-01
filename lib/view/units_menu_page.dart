import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:convertouch/view/items_menu/items_menu_view.dart';
import 'package:convertouch/view/scaffold/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitsMenuPage extends StatelessWidget {
  const ConvertouchUnitsMenuPage({super.key});

  static const int _selectedUnitsMinNum = 2;

  @override
  Widget build(BuildContext context) {
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
            BlocBuilder<UnitsMenuBloc, UnitsMenuState>(buildWhen: (prev, next) {
              return prev != next && next is UnitsSelected;
            }, builder: (_, unitsMenuState) {
              bool isButtonEnabled = unitsMenuState is UnitsSelected &&
                  unitsMenuState.selectedUnits.length >= _selectedUnitsMinNum;
              return IconButton(
                icon: Icon(
                  Icons.check,
                  color: isButtonEnabled ? const Color(0xFF426F99) : null,
                ),
                disabledColor: const Color(0xFFA0C4F5),
                onPressed: isButtonEnabled ? () {} : null,
              );
            }),
          ],
        ),
        body: Column(
          children: [
            const ConvertouchSearchBar(searchBarPlaceholder: "Search units..."),
            Expanded(
                child: BlocBuilder<UnitsMenuBloc, UnitsMenuState>(
                    buildWhen: (prev, next) {
              return prev != next && next is UnitsFetched;
            }, builder: (_, unitsMenuState) {
              List<UnitModel> units =
                  unitsMenuState is UnitsFetched ? unitsMenuState.units : [];
              return BlocBuilder<ItemsMenuViewBloc, ItemsMenuViewState>(
                  builder: (_, itemsMenuViewState) {
                return ConvertouchItemsMenuView(
                    units, itemsMenuViewState.itemsMenuView);
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
  }
}
