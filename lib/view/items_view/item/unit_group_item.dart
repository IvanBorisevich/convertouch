import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_grid_item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_list_item.dart';
import 'package:convertouch/view/style/model/menu_item_colors.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitGroupItem extends ConvertouchItem {
  static const double itemLogoWidth = 50;

  ConvertouchUnitGroupItem(
    this.unitGroup,
    ConvertouchItem item,
    this.unitGroupColors,
  ) : super.fromItem(item);

  final UnitGroupModel unitGroup;
  ConvertouchMenuItemColors unitGroupColors;

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
      itemColors: unitGroupColors,
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
      itemColors: unitGroupColors,
    );
  }

  Widget _buildUnitGroupIconButton() {
    return IconButton(
      onPressed: null,
      icon: ImageIcon(
        AssetImage("$iconPathPrefix/${unitGroup.iconName}"),
        color: isSelected
            ? unitGroupColors.contentColorSelected
            : unitGroupColors.contentColor,
        size: 35,
      ),
    );
  }
}
