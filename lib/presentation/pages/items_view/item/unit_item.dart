import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/pages/items_view/item/item.dart';
import 'package:convertouch/presentation/pages/items_view/item_view_mode/menu_grid_item.dart';
import 'package:convertouch/presentation/pages/items_view/item_view_mode/menu_list_item.dart';
import 'package:convertouch/presentation/pages/style/model/menu_item_colors.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitItem extends ConvertouchItem {
  static const double itemLogoWidth = 65;

  ConvertouchUnitItem(
    this.unit,
    ConvertouchItem item,
    this.unitColors,
  ) : super.fromItem(item);

  final UnitModel unit;
  ConvertouchMenuItemColors unitColors;

  @override
  Widget buildForGrid() {
    return ConvertouchMenuGridItem(
      unit,
      logo: _buildUnitItemAbbreviation(),
      onTap: onTap,
      onLongPress: onLongPress,
      onSelectForRemoval: onSelectForRemoval,
      onDeselectForRemoval: onDeselectForRemoval,
      isMarkedToSelect: isMarkedToSelect,
      selected: selected,
      selectedForRemoval: selectedForRemoval,
      removalMode: removalMode,
      markOnTap: markOnTap,
      itemColors: unitColors,
    );
  }

  @override
  Widget buildForList() {
    return ConvertouchMenuListItem(
      unit,
      logo: wrapLogo(_buildUnitItemAbbreviation(), itemLogoWidth),
      onTap: onTap,
      onLongPress: onLongPress,
      onSelectForRemoval: onSelectForRemoval,
      onDeselectForRemoval: onDeselectForRemoval,
      isMarkedToSelect: isMarkedToSelect,
      selected: selected,
      selectedForRemoval: selectedForRemoval,
      removalMode: removalMode,
      markOnTap: markOnTap,
      itemColors: unitColors,
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
