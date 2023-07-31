import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/view/items_view/item_view_mode/unit_value_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitValueItem extends ConvertouchItem {
  static const Color borderColor = Color(0xFF7FA0BE);
  static const Color borderColorSelected = Color(0xFF375067);
  static const Color unitButtonBackgroundColor = Color(0xFFE2EEF8);
  static const Color unitButtonBackgroundColorSelected = Color(0xFFB9D7F1);
  static const Color unitButtonTextColor = Color(0xFF426F99);
  static const Color unitButtonTextColorSelected = Color(0xFF2D4B67);

  const ConvertouchUnitValueItem(this.unitValue, {
    void Function()? onTap,
    void Function()? onLongPress,
    void Function(String)? onValueChanged,
    bool isMarkedToSelect = false,
    bool removalModeEnabled = false,
    bool markOnTap = false,
  }) : super(
    onTap: onTap,
    onLongPress: onLongPress,
    onValueChanged: onValueChanged,
    isMarkedToSelect: isMarkedToSelect,
    removalModeEnabled: removalModeEnabled,
    markOnTap: markOnTap,
  );

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
      borderColor: borderColor,
      borderColorSelected: borderColorSelected,
      unitButtonBackgroundColor: unitButtonBackgroundColor,
      unitButtonBackgroundColorSelected: unitButtonBackgroundColorSelected,
      unitButtonTextColor: unitButtonTextColor,
      unitButtonTextColorSelected: unitButtonTextColorSelected,
    );
  }
}