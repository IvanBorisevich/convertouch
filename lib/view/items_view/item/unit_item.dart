import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_grid_item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitItem extends ConvertouchItem {
  static const double itemLogoWidth = 65;
  static const Color borderColor = Color(0xFFB5DBFF);
  static const Color borderColorMarked = Color(0xFF509CE0);
  static const Color borderColorSelected = Color(0xFF2F7DC2);
  static const Color backgroundColor = Color(0xFFDFEDFF);
  static const Color backgroundColorMarked = Color(0xFFCCE1FF);
  static const Color backgroundColorSelected = Color(0xFF95BBF3);
  static const Color contentColor = Color(0xFF366C9F);
  static const Color contentColorMarked = Color(0xFF366C9F);
  static const Color contentColorSelected = Color(0xFF0A4175);

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
      borderColor: borderColor,
      borderColorMarked: borderColorMarked,
      borderColorSelected: borderColorSelected,
      backgroundColor: backgroundColor,
      backgroundColorMarked: backgroundColorMarked,
      backgroundColorSelected: backgroundColorSelected,
      contentColor: contentColor,
      contentColorMarked: contentColorMarked,
      contentColorSelected: contentColorSelected,
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
      borderColor: borderColor,
      borderColorMarked: borderColorMarked,
      borderColorSelected: borderColorSelected,
      backgroundColor: backgroundColor,
      backgroundColorMarked: backgroundColorMarked,
      backgroundColorSelected: backgroundColorSelected,
      contentColor: contentColor,
      contentColorMarked: contentColorMarked,
      contentColorSelected: contentColorSelected,
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
