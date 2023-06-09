import 'package:convertouch/model/entity/id_name_model.dart';
import 'package:convertouch/model/constant/constant.dart';
import 'package:convertouch/view/items_menu/item/list_item.dart';
import 'package:flutter/material.dart';


class ConvertouchItemsList extends StatelessWidget {
  const ConvertouchItemsList(this.items, this.itemType, {super.key});

  final List<IdNameModel> items;
  final ItemModelType itemType;

  static const double listItemsSpacingSize = 5;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(listItemsSpacingSize),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return ConvertouchListItem(items[index], itemType);
      },
      separatorBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
              listItemsSpacingSize,
              listItemsSpacingSize,
              listItemsSpacingSize,
              index == items.length - 1 ? listItemsSpacingSize : 0)),
    );
  }
}
