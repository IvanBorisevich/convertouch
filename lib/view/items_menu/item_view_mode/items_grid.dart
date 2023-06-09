import 'package:convertouch/model/constant/constant.dart';
import 'package:convertouch/model/entity/id_name_model.dart';
import 'package:convertouch/view/items_menu/item/grid_item.dart';
import 'package:flutter/material.dart';

class ConvertouchItemsGrid extends StatelessWidget {
  const ConvertouchItemsGrid(this.items, this.itemType, {super.key});

  final List<IdNameModel> items;
  final ItemModelType itemType;

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
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ConvertouchGridItem(items[index], itemType);
      },
    );
  }
}
