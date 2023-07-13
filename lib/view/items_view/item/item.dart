import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/view/items_view/item/unit_group_item.dart';
import 'package:convertouch/view/items_view/item/unit_item.dart';
import 'package:convertouch/view/items_view/item/unit_value_item.dart';
import 'package:flutter/material.dart';

abstract class ConvertouchItem {
  const ConvertouchItem({
    this.onPressed,
    this.isSelected = false,
  });

  final void Function()? onPressed;
  final bool isSelected;

  factory ConvertouchItem.createItem(ItemModel item,
      {void Function()? onPressed, bool isSelected = false}) {
    switch (item.itemType) {
      case ItemType.unitGroup:
        return ConvertouchUnitGroupItem(item as UnitGroupModel,
            onPressed: onPressed, isSelected: isSelected);
      case ItemType.unit:
        return ConvertouchUnitItem(item as UnitModel,
            onPressed: onPressed, isSelected: isSelected);
      case ItemType.unitValue:
        return ConvertouchUnitValueItem(item as UnitValueModel,
            onPressed: onPressed, isSelected: isSelected);
    }
  }

  Widget buildForList(BuildContext context);

  Widget buildForGrid(BuildContext context);

  void Function()? onPressedFunc(BuildContext context) {
    return onPressed;
  }

  Widget wrapLogo(Widget logo, double wrapWidth) {
    return Container(
      width: wrapWidth,
      decoration: const BoxDecoration(
        color: Color(0x00FFFFFF),
      ),
      child: logo,
    );
  }
}
