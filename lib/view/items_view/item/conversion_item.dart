import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/view/items_view/item_view_mode/unit_value_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:convertouch/view/style/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItem extends ConvertouchItem {
  ConvertouchConversionItem(this.unitValue, ConvertouchItem baseItem)
      : super.fromItem(baseItem) {
    if (itemColors == defaultItemColors) {
      itemColors = conversionItemColors[ConvertouchUITheme.light]!;
    }
  }

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
      itemColors: itemColors,
    );
  }
}