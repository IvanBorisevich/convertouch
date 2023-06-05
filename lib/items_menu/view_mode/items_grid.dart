import 'package:flutter/material.dart';

import 'package:convertouch/items_menu/item/unit_group_grid_item.dart';

class ConvertouchItemsGrid extends StatelessWidget {
  const ConvertouchItemsGrid(this.itemsNames, {super.key});

  final List<String> itemsNames;

  static const double listItemsSpacingSize = 5.0;
  static const int numberOfItemsInRow = 4;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: numberOfItemsInRow,
        mainAxisSpacing: listItemsSpacingSize,
        crossAxisSpacing: listItemsSpacingSize,
      ),
      padding: const EdgeInsets.all(listItemsSpacingSize),
      itemCount: itemsNames.length,
      itemBuilder: (context, index) {
        return ConvertouchUnitGroupGridItem(itemsNames[index]);
      },
    );
  }
}
