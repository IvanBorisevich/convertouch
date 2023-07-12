import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_grid_item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';

class ConvertouchUnitItem extends ConvertouchItem {
  static const double itemLogoWidth = 65;

  ConvertouchUnitItem(this.unit, {
    void Function()? onPressed
  }) : super(onPressed: onPressed);

  final UnitModel unit;

  @override
  Widget buildForGrid(BuildContext context) {
    return ConvertouchMenuGridItem(
      unit,
      logo: _buildUnitItemAbbreviation(),
      onPressed: onPressedFunc(context),
      itemNameMaxLines: getGridItemNameLinesNumToWrap(unit.name),
    );
  }

  @override
  Widget buildForList(BuildContext context) {
    return ConvertouchMenuListItem(unit,
        logo: wrapLogo(_buildUnitItemAbbreviation(), itemLogoWidth),
        onPressed: onPressedFunc(context)
    );
  }

  @override
  void onClickByDefault(BuildContext context) {}

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
