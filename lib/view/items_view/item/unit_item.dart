import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_grid_item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:convertouch/view/style/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitItem extends ConvertouchItem {
  static const double itemLogoWidth = 65;

  ConvertouchUnitItem(this.unit, ConvertouchItem item) : super.fromItem(item) {
    if (itemColors == defaultItemColors) {
      itemColors = unitItemColors[ConvertouchUITheme.light]!;
    }
  }

  final UnitModel unit;

  @override
  Widget buildForGrid() {
    return ConvertouchMenuGridItem(
      unit,
      logo: _buildUnitItemAbbreviation(),
      onTap: onTap,
      onLongPress: onLongPress,
      isMarkedToSelect: isMarkedToSelect,
      isSelected: isSelected,
      removalModeEnabled: removalModeEnabled,
      markOnTap: markOnTap,
      itemColors: itemColors,
    );
  }

  @override
  Widget buildForList() {
    return ConvertouchMenuListItem(
      unit,
      logo: wrapLogo(_buildUnitItemAbbreviation(), itemLogoWidth),
      onTap: onTap,
      onLongPress: onLongPress,
      isMarkedToSelect: isMarkedToSelect,
      isSelected: isSelected,
      removalModeEnabled: removalModeEnabled,
      markOnTap: markOnTap,
      itemColors: itemColors,
    );
  }

  Widget _buildUnitItemAbbreviation() {
    return Center(
      child: Text(
        unit.abbreviation,
      ),
    );
  }
}
