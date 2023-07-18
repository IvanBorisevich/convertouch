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
    this.onValueChanged,
    this.isMarkedToSelect = false,
  });

  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function(String)? onValueChanged;
  final bool isMarkedToSelect;

  factory ConvertouchItem.createItem(ItemModel item, {
    void Function()? onTap,
    void Function()? onLongPress,
    void Function(String)? onValueChanged,
    bool isSelected = false}) {
    switch (item.itemType) {
      case ItemType.unitGroup:
        return ConvertouchUnitGroupItem(item as UnitGroupModel,
            onTap: onTap,
            onLongPress: onLongPress,
            onValueChanged: onValueChanged,
            isSelected: isSelected);
      case ItemType.unit:
        return ConvertouchUnitItem(item as UnitModel,
            onTap: onTap,
            onLongPress: onLongPress,
            onValueChanged: onValueChanged,
            isSelected: isSelected);
      case ItemType.unitValue:
        return ConvertouchUnitValueItem(item as UnitValueModel,
            onTap: onTap,
            onLongPress: onLongPress,
            onValueChanged: onValueChanged,
            isSelected: isSelected);
    }
  }

  Widget buildForList();

  Widget buildForGrid();

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
