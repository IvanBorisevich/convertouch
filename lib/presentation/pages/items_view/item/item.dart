import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/entities/item_entity.dart';
import 'package:convertouch/domain/entities/unit_group_entity.dart';
import 'package:convertouch/domain/entities/unit_entity.dart';
import 'package:convertouch/domain/entities/unit_value_entity.dart';
import 'package:convertouch/presentation/pages/items_view/item/conversion_item.dart';
import 'package:convertouch/presentation/pages/items_view/item/unit_group_item.dart';
import 'package:convertouch/presentation/pages/items_view/item/unit_item.dart';
import 'package:convertouch/presentation/pages/scaffold/scaffold.dart';
import 'package:convertouch/presentation/pages/style/colors.dart';
import 'package:convertouch/presentation/pages/style/model/conversion_item_colors.dart';
import 'package:convertouch/presentation/pages/style/model/item_colors.dart';
import 'package:convertouch/presentation/pages/style/model/menu_item_colors.dart';
import 'package:flutter/material.dart';

class ConvertouchItem {
  void Function()? onTap;
  void Function()? onLongPress;
  void Function(String)? onValueChanged;
  bool isMarkedToSelect = false;
  bool isSelected = false;
  bool removalModeEnabled = false;
  bool markOnTap = false;
  ConvertouchItemColors? itemColors;

  ConvertouchItem._({
    this.onTap,
    this.onLongPress,
    this.onValueChanged,
    required this.isMarkedToSelect,
    required this.isSelected,
    required this.removalModeEnabled,
    required this.markOnTap,
    this.itemColors,
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
    ItemEntity item, {
    void Function()? onTap,
    void Function()? onLongPress,
    void Function(String)? onValueChanged,
    bool isMarkedToSelect = false,
    bool isSelected = false,
    bool removalModeEnabled = false,
    bool markOnTap = false,
    ConvertouchItemColors? itemColors,
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
        ConvertouchMenuItemColors unitGroupColors = itemColors != null
            ? itemColors as ConvertouchMenuItemColors
            : unitGroupItemColors[ConvertouchUITheme.light]!;
        return ConvertouchUnitGroupItem(
          item as UnitGroupEntity,
          baseItem,
          unitGroupColors,
        );
      case ItemType.unit:
        ConvertouchMenuItemColors unitColors = itemColors != null
            ? itemColors as ConvertouchMenuItemColors
            : unitItemColors[ConvertouchUITheme.light]!;
        return ConvertouchUnitItem(
          item as UnitEntity,
          baseItem,
          unitColors,
        );
      case ItemType.unitValue:
        ConvertouchConversionItemColors conversionColors = itemColors != null
            ? itemColors as ConvertouchConversionItemColors
            : conversionItemColors[ConvertouchUITheme.light]!;
        return ConvertouchConversionItem(
          item as UnitValueEntity,
          baseItem,
          conversionColors,
        );
    }
  }

  Widget buildForList() {
    return empty();
  }

  Widget buildForGrid() {
    return empty();
  }

  Widget wrapLogo(Widget logo, double wrapWidth) {
    return SizedBox(
      width: wrapWidth,
      child: logo,
    );
  }
}
