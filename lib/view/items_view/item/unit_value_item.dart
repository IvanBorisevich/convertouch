import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/view/items_view/item_view_mode/unit_value_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitValueItem extends ConvertouchItem {
  const ConvertouchUnitValueItem(this.unitValue, {
    void Function()? onTap,
    void Function()? onLongPress,
    void Function(String)? onValueChanged,
    bool isSelected = false,
  }) : super(
      onTap: onTap,
      onLongPress: onLongPress,
      onValueChanged: onValueChanged,
      isMarkedToSelect: isSelected);

  final UnitValueModel unitValue;

  @override
  Widget buildForGrid() {
    throw UnimplementedError();
  }

  @override
  Widget buildForList() {
    return ConvertouchUnitValueListItem(
      unitValue,
      onTap: onTap,
      onLongPress: onLongPress,
      onValueChanged: onValueChanged,
    );
  }
}