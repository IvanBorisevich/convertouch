import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/items_menu_view_mode.dart';
import 'package:convertouch/view/items_model/menu_grid_item.dart';
import 'package:convertouch/view/items_model/menu_list_item.dart';
import 'package:flutter/cupertino.dart';

class ConvertouchItemsMenuView extends StatelessWidget {
  const ConvertouchItemsMenuView(this.items, this.itemsMenuViewMode, {super.key});

  final List<ItemModel> items;
  final ItemsMenuViewMode itemsMenuViewMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      switch (itemsMenuViewMode) {
        case ItemsMenuViewMode.grid:
          return ConvertouchItemsGrid(items);
        case ItemsMenuViewMode.list:
          return ConvertouchItemsList(items);
      }
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
        return ConvertouchMenuGridItem(items[index]);
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
        return ConvertouchMenuListItem(items[index]);
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


