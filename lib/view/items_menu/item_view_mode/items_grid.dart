import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/view/items_menu/item/grid_item.dart';
import 'package:flutter/material.dart';

class ConvertouchItemsGrid extends StatefulWidget {
  const ConvertouchItemsGrid(this.items, {super.key});

  final List<ItemModel> items;

  @override
  State<ConvertouchItemsGrid> createState() => _ConvertouchItemsGridState();
}

class _ConvertouchItemsGridState extends State<ConvertouchItemsGrid> {
  static const double _listItemsSpacingSize = 5.0;
  static const int _numberOfItemsInRow = 4;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _numberOfItemsInRow,
        mainAxisSpacing: _listItemsSpacingSize,
        crossAxisSpacing: _listItemsSpacingSize,
      ),
      padding: const EdgeInsets.all(_listItemsSpacingSize),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return ConvertouchGridItem(widget.items[index]);
      },
    );
  }
}
