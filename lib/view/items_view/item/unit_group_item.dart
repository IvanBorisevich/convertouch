import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_grid_item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitGroupItem extends ConvertouchItem {
  static const double itemLogoWidth = 50;
  static const Color borderColor = Color(0xFFC2CCFF);
  static const Color borderColorSelected = Color(0xFFA5B2FF);
  static const Color backgroundColor = Color(0xFFECF0FF);
  static const Color backgroundColorSelected = Color(0xFFD6DCFF);
  static const Color contentColor = Color(0xFF504EB6);
  static const Color contentColorSelected = Color(0xFF2E2C8A);

  const ConvertouchUnitGroupItem(this.unitGroup, {
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

  final UnitGroupModel unitGroup;

  @override
  Widget buildForGrid() {
    return ConvertouchMenuGridItem(
      unitGroup,
      logo: _buildUnitGroupIconButton(),
      onTap: onTap,
      onLongPress: onLongPress,
      isMarkedToSelect: isMarkedToSelect,
      isSelected: isSelected,
      removalModeEnabled: removalModeEnabled,
      markOnTap: markOnTap,
      borderColor: borderColor,
      borderColorSelected: borderColorSelected,
      backgroundColor: backgroundColor,
      backgroundColorSelected: backgroundColorSelected,
      contentColor: contentColor,
      contentColorSelected: contentColorSelected,
    );
  }

  @override
  Widget buildForList() {
    return ConvertouchMenuListItem(
      unitGroup,
      logo: wrapLogo(_buildUnitGroupIconButton(), itemLogoWidth),
      onTap: onTap,
      onLongPress: onLongPress,
      isMarkedToSelect: isMarkedToSelect,
      isSelected: isSelected,
      removalModeEnabled: removalModeEnabled,
      markOnTap: markOnTap,
      borderColor: borderColor,
      borderColorSelected: borderColorSelected,
      backgroundColor: backgroundColor,
      backgroundColorSelected: backgroundColorSelected,
      contentColor: contentColor,
      contentColorSelected: contentColorSelected,
    );
  }

  Widget _buildUnitGroupIconButton() {
    return IconButton(
      onPressed: null,
      icon: ImageIcon(
        AssetImage("$iconPathPrefix/${unitGroup.iconName}"),
        color: isSelected ? contentColorSelected : contentColor,
        size: 35,
      ),
    );
  }
}