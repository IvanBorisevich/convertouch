import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_grid_item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_list_item.dart';
import 'package:convertouch/view/style/colors.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitGroupItem extends ConvertouchItem {
  static const double itemLogoWidth = 50;

  ConvertouchUnitGroupItem(this.unitGroup, ConvertouchItem item)
      : super.fromItem(item) {
    if (itemColors == defaultItemColors) {
      itemColors = unitGroupItemColors[ConvertouchUITheme.light]!;
    }
  }

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
      itemColors: itemColors,
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
      itemColors: itemColors,
    );
  }

  Widget _buildUnitGroupIconButton() {
    return IconButton(
      onPressed: null,
      icon: ImageIcon(
        AssetImage("$iconPathPrefix/${unitGroup.iconName}"),
        color: isSelected
            ? itemColors.contentColorSelected
            : itemColors.contentColor,
        size: 35,
      ),
    );
  }
}
