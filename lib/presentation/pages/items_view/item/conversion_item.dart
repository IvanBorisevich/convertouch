import 'package:convertouch/domain/entities/unit_value_entity.dart';
import 'package:convertouch/presentation/pages/items_view/item/item.dart';
import 'package:convertouch/presentation/pages/items_view/item_view_mode/unit_value_list_item.dart';
import 'package:convertouch/presentation/pages/style/model/conversion_item_colors.dart';
import 'package:flutter/material.dart';

class ConvertouchConversionItem extends ConvertouchItem {
  ConvertouchConversionItem(
    this.unitValue,
    ConvertouchItem baseItem,
    this.conversionColors,
  ) : super.fromItem(baseItem);

  final UnitValueEntity unitValue;
  final ConvertouchConversionItemColors conversionColors;

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
      itemColors: conversionColors,
    );
  }
}
