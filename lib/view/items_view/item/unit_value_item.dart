import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/view/items_view/item_view_mode/unit_value_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitValueItem extends ConvertouchItem {
  const ConvertouchUnitValueItem(
    this.unitValue, {
    void Function()? onPressed,
    bool isSelected = false,
  }) : super(onPressed: onPressed, isSelected: isSelected);

  final UnitValueModel unitValue;

  @override
  Widget buildForGrid(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildForList(BuildContext context) {
    return ConvertouchUnitValueListItem(unitValue);
  }
}