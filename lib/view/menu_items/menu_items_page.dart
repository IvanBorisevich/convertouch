import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/menu_view.dart';
import 'package:convertouch/presenter/bloc/menu_view_bloc.dart';
import 'package:convertouch/presenter/bloc/menu_items_bloc.dart';
import 'package:convertouch/presenter/states/menu_view_state.dart';
import 'package:convertouch/presenter/states/menu_items_state.dart';
import 'package:convertouch/view/menu_items/item_view_mode/items_list.dart';
import 'package:convertouch/view/menu_items/item_view_mode/items_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchItemsMenuPage extends StatelessWidget {
  const ConvertouchItemsMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF6F9FF),
        ),
        child: BlocBuilder<MenuViewBloc, MenuViewModeState>(
            builder: (_, menuViewModeState) {

          return BlocBuilder<MenuItemsBloc, MenuItemsState>(
              builder: (_, menuItemsChangedState) {
            List<ItemModel> items = menuItemsChangedState.items;

            return LayoutBuilder(builder: (context, constraints) {
              switch (menuViewModeState.menuViewMode) {
                case MenuView.grid:
                  return ConvertouchItemsGrid(items);
                case MenuView.list:
                  return ConvertouchItemsList(items);
              }
            });
          });
        }),
      ),
    );
  }
}
