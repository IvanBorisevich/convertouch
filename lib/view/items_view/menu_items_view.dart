import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/util/menu_page_util.dart';
import 'package:convertouch/presenter/bloc/items_menu_view_bloc.dart';
import 'package:convertouch/presenter/states/items_menu_view_state.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchMenuItemsView extends StatelessWidget {
  const ConvertouchMenuItemsView(this.items, {super.key});

  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsMenuViewBloc, ItemsMenuViewState>(
        builder: (_, itemsMenuViewState) {
      return LayoutBuilder(builder: (context, constraints) {
        if (items.isNotEmpty) {
          switch (itemsMenuViewState.itemsMenuView) {
            case ItemsMenuViewMode.grid:
              return ConvertouchItemsGrid(items);
            case ItemsMenuViewMode.list:
              return ConvertouchItemsList(items);
          }
        }
        return const ConvertouchItemsEmptyView();
      });
    });
  }
}

class ConvertouchItemsGrid extends StatelessWidget {
  const ConvertouchItemsGrid(this.items, {super.key});

  static const double _listItemsSpacingSize = 5.0;
  static const int _numberOfItemsInRow = 4;

  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _numberOfItemsInRow,
        mainAxisSpacing: _listItemsSpacingSize,
        crossAxisSpacing: _listItemsSpacingSize,
      ),
      padding: const EdgeInsets.all(_listItemsSpacingSize),
      itemBuilder: (context, index) {
        return ConvertouchItem.createItem(items[index]).buildForGrid(context);
      },
    );
  }
}

class ConvertouchItemsList extends StatelessWidget {
  const ConvertouchItemsList(this.items, {super.key});

  static const double _listItemsSpacingSize = 5;

  final List<ItemModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(_listItemsSpacingSize),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ConvertouchItem.createItem(items[index]).buildForList(context);
      },
      separatorBuilder: (context, index) => Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
            _listItemsSpacingSize,
            _listItemsSpacingSize,
            _listItemsSpacingSize,
            index == items.length - 1 ? _listItemsSpacingSize : 0),
      ),
    );
  }
}

class ConvertouchItemsEmptyView extends StatelessWidget {
  const ConvertouchItemsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Center(
          child: Text(
        "No Items",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      )),
    );
  }
}