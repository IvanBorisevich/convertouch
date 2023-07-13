import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_grid_item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchUnitItem extends ConvertouchItem {
  static const double itemLogoWidth = 65;

  ConvertouchUnitItem(this.unit, {
    void Function()? onPressed,
    bool isSelected = false,
  }) : super(onPressed: onPressed, isSelected: isSelected);

  final UnitModel unit;

  @override
  Widget buildForGrid(BuildContext context) {
    return ConvertouchMenuGridItem(
      unit,
      logo: _buildUnitItemAbbreviation(),
      onPressed: onPressedFunc(context),
      changeItemStateOnPress: true,
      isSelected: super.isSelected,
    );
  }

  @override
  Widget buildForList(BuildContext context) {
    return ConvertouchMenuListItem(
      unit,
      logo: wrapLogo(_buildUnitItemAbbreviation(), itemLogoWidth),
      onPressed: onPressedFunc(context),
      changeItemStateOnPress: true,
      isSelected: super.isSelected,
    );
  }

  @override
  void Function()? onPressedFunc(BuildContext context) {
    return () {
      BlocProvider.of<UnitsMenuBloc>(context).add(SelectUnit(unitId: unit.id));
    };
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
