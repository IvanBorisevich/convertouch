import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_grid_item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitGroupItem extends ConvertouchItem {
  static const double itemLogoWidth = 50;

  const ConvertouchUnitGroupItem(this.unitGroup, {
    void Function()? onTap,
    void Function()? onLongPress,
    void Function(String)? onValueChanged,
    bool isSelected = false,
  }) : super(
      onTap: onTap,
      onLongPress: onLongPress,
      onValueChanged: onValueChanged,
      isMarkedToSelect: isSelected);

  final UnitGroupModel unitGroup;

  @override
  Widget buildForGrid() {
    return ConvertouchMenuGridItem(
      unitGroup,
      logo: _buildUnitGroupIconButton(),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  @override
  Widget buildForList() {
    return ConvertouchMenuListItem(unitGroup,
      logo: wrapLogo(_buildUnitGroupIconButton(), itemLogoWidth),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }

  Widget _buildUnitGroupIconButton() {
    return IconButton(
      onPressed: null,
      icon: ImageIcon(
        AssetImage("$iconPathPrefix/${unitGroup.iconName}"),
        color: const Color(0xFF366C9F),
        size: 35,
      ),
    );
  }
}