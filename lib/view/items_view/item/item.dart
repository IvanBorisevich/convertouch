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
    this.onTap,
    this.onLongPress,
    this.isMarkedToSelect = false,
  });

  final void Function()? onTap;
  final void Function()? onLongPress;
  final bool isMarkedToSelect;

  factory ConvertouchItem.createItem(ItemModel item,
      {void Function()? onTap, bool isSelected = false}) {
    switch (item.itemType) {
      case ItemType.unitGroup:
        return ConvertouchUnitGroupItem(item as UnitGroupModel,
            onTap: onTap, isSelected: isSelected);
      case ItemType.unit:
        return ConvertouchUnitItem(item as UnitModel,
            onTap: onTap, isSelected: isSelected);
      case ItemType.unitValue:
        return ConvertouchUnitValueItem(item as UnitValueModel,
            onTap: onTap, isSelected: isSelected);
    }
  }

  Widget buildForList(BuildContext context);

  Widget buildForGrid(BuildContext context);

  void Function()? onTapFunc(BuildContext context) {
    return onTap;
  }

  void Function()? onLongPressFunc(BuildContext context) {
    return onLongPress;
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
