import 'package:flutter/material.dart';

import 'package:convertouch/items_menu/item/unit_group_grid_item.dart';

class ConvertouchItemsGrid extends StatelessWidget {
  const ConvertouchItemsGrid(this.itemsNames, {super.key});

  static const double listItemsSpacingSize = 5;
  final List<String> itemsNames;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(5),
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 4,
        children: itemsNames
            .map((itemName) => ConvertouchUnitGroupGridItem(itemName))
            .toList());
  }
}
