import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_grid_item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitItem extends ConvertouchItem {
  static const double itemLogoWidth = 65;

  ConvertouchUnitItem(this.unit, {
    void Function()? onTap,
    void Function()? onLongPress,
    void Function(String)? onValueChanged,
    bool isMarkedToSelect = false,
    bool isSelected = false,
    bool removalModeEnabled = false,
    bool markOnTap = false,
  }) : super(
    onTap: onTap,
    onLongPress: onLongPress,
    onValueChanged: onValueChanged,
    isMarkedToSelect: isMarkedToSelect,
    isSelected: isSelected,
    removalModeEnabled: removalModeEnabled,
    markOnTap: markOnTap,
  );

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
    );
  }

  Widget _buildUnitItemAbbreviation() {
    return Center(
      child: Text(
        unit.abbreviation,
        style: const TextStyle(
          fontFamily: quicksandFontFamily,
          fontWeight: FontWeight.w700,
          color: Color(0xFF366C9F),
          fontSize: 16,
        ),
      ),
    );
  }
}
