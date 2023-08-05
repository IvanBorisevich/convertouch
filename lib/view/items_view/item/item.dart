import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/view/items_view/item/conversion_item.dart';
import 'package:convertouch/view/items_view/item/unit_group_item.dart';
import 'package:convertouch/view/items_view/item/unit_item.dart';
import 'package:convertouch/view/scaffold/scaffold.dart';
import 'package:convertouch/view/style/colors.dart';
import 'package:convertouch/view/style/model/item_colors.dart';
import 'package:flutter/material.dart';

class ConvertouchItem {
  void Function()? onTap;
  void Function()? onLongPress;
  void Function(String)? onValueChanged;
  bool isMarkedToSelect = false;
  bool isSelected = false;
  bool removalModeEnabled = false;
  bool markOnTap = false;
  ConvertouchItemColors itemColors = defaultItemColors;

  ConvertouchItem._({
    this.onTap,
    this.onLongPress,
    this.onValueChanged,
    required this.isMarkedToSelect,
    required this.isSelected,
    required this.removalModeEnabled,
    required this.markOnTap,
    required this.itemColors,
  });

  ConvertouchItem.fromItem(ConvertouchItem baseItem) {
    onTap = baseItem.onTap;
    onLongPress = baseItem.onLongPress;
    onValueChanged = baseItem.onValueChanged;
    isMarkedToSelect = baseItem.isMarkedToSelect;
    isSelected = baseItem.isSelected;
    removalModeEnabled = baseItem.removalModeEnabled;
    markOnTap = baseItem.markOnTap;
    itemColors = baseItem.itemColors;
  }

  factory ConvertouchItem.createItem(
    ItemModel item, {
    void Function()? onTap,
    void Function()? onLongPress,
    void Function(String)? onValueChanged,
    bool isMarkedToSelect = false,
    bool isSelected = false,
    bool removalModeEnabled = false,
    bool markOnTap = false,
    ConvertouchItemColors itemColors = defaultItemColors,
  }) {
    ConvertouchItem baseItem = ConvertouchItem._(
      onTap: onTap,
      onLongPress: onLongPress,
      onValueChanged: onValueChanged,
      isMarkedToSelect: isMarkedToSelect,
      isSelected: isSelected,
      removalModeEnabled: removalModeEnabled,
      markOnTap: markOnTap,
      itemColors: itemColors,
    );
    switch (item.itemType) {
      case ItemType.unitGroup:
        return ConvertouchUnitGroupItem(item as UnitGroupModel, baseItem);
      case ItemType.unit:
        return ConvertouchUnitItem(item as UnitModel, baseItem);
      case ItemType.unitValue:
        return ConvertouchConversionItem(item as UnitValueModel, baseItem);
    }
  }

  Widget buildForList() {
    return empty();
  }

  Widget buildForGrid() {
    return empty();
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
