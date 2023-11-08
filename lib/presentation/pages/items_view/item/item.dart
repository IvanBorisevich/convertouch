import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
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
  void Function()? onSelectForRemoval;
  void Function()? onDeselectForRemoval;
  bool isMarkedToSelect = false;
  bool selected = false;
  bool selectedForRemoval = false;
  bool removalMode = false;
  bool markOnTap = false;
  ConvertouchItemColors? itemColors;

  ConvertouchItem._({
    this.onTap,
    this.onLongPress,
    this.onValueChanged,
    this.onSelectForRemoval,
    this.onDeselectForRemoval,
    required this.isMarkedToSelect,
    required this.selected,
    required this.selectedForRemoval,
    required this.removalMode,
    required this.markOnTap,
    this.itemColors,
  });

  ConvertouchItem.fromItem(ConvertouchItem baseItem) {
    onTap = baseItem.onTap;
    onLongPress = baseItem.onLongPress;
    onValueChanged = baseItem.onValueChanged;
    onSelectForRemoval = baseItem.onSelectForRemoval;
    onDeselectForRemoval = baseItem.onDeselectForRemoval;
    isMarkedToSelect = baseItem.isMarkedToSelect;
    selected = baseItem.selected;
    selectedForRemoval = baseItem.selectedForRemoval;
    removalMode = baseItem.removalMode;
    markOnTap = baseItem.markOnTap;
    itemColors = baseItem.itemColors;
  }

  factory ConvertouchItem.createItem(
    ItemModel item, {
    void Function()? onTap,
    void Function()? onLongPress,
    void Function(String)? onValueChanged,
    void Function()? onSelectForRemoval,
    void Function()? onDeselectForRemoval,
    bool isMarkedToSelect = false,
    bool selected = false,
    bool selectedForRemoval = false,
    bool removalMode = false,
    bool markOnTap = false,
    ConvertouchItemColors? itemColors,
  }) {
    ConvertouchItem baseItem = ConvertouchItem._(
      onTap: onTap,
      onLongPress: onLongPress,
      onValueChanged: onValueChanged,
      onSelectForRemoval: onSelectForRemoval,
      onDeselectForRemoval: onDeselectForRemoval,
      isMarkedToSelect: isMarkedToSelect,
      selected: selected,
      selectedForRemoval: selectedForRemoval,
      removalMode: removalMode,
      markOnTap: markOnTap,
      itemColors: itemColors,
    );
    switch (item.itemType) {
      case ItemType.unitGroup:
        ConvertouchMenuItemColors unitGroupColors = itemColors != null
            ? itemColors as ConvertouchMenuItemColors
            : unitGroupItemColors[ConvertouchUITheme.light]!;
        return ConvertouchUnitGroupItem(
          item as UnitGroupModel,
          baseItem,
          unitGroupColors,
        );
      case ItemType.unit:
        ConvertouchMenuItemColors unitColors = itemColors != null
            ? itemColors as ConvertouchMenuItemColors
            : unitItemColors[ConvertouchUITheme.light]!;
        return ConvertouchUnitItem(
          item as UnitModel,
          baseItem,
          unitColors,
        );
      case ItemType.unitValue:
        ConvertouchConversionItemColors conversionColors = itemColors != null
            ? itemColors as ConvertouchConversionItemColors
            : conversionItemColors[ConvertouchUITheme.light]!;
        return ConvertouchConversionItem(
          item as UnitValueModel,
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
