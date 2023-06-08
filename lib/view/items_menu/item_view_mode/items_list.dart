import 'package:convertouch/view/items_menu/item/unit_group_list_item.dart';
import 'package:flutter/material.dart';


class ConvertouchItemsList extends StatelessWidget {
  const ConvertouchItemsList(this.itemsNames, {super.key});

  static const double listItemsSpacingSize = 5;
  final List<String> itemsNames;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(listItemsSpacingSize),
      itemCount: itemsNames.length,
      itemBuilder: (BuildContext context, int index) {
        return ConvertouchUnitGroupListItem(itemsNames[index]);
      },
      separatorBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
              listItemsSpacingSize,
              listItemsSpacingSize,
              listItemsSpacingSize,
              index == itemsNames.length - 1 ? listItemsSpacingSize : 0)),
    );
  }
}
