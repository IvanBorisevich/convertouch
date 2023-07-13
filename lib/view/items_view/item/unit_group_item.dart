import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/bloc/units_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_grid_item.dart';
import 'package:convertouch/view/items_view/item_view_mode/menu_list_item.dart';
import 'package:convertouch/view/items_view/item/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ConvertouchUnitGroupItem extends ConvertouchItem {
  static const double itemLogoWidth = 50;

  const ConvertouchUnitGroupItem(this.unitGroup, {
    void Function()? onPressed,
    bool isSelected = false,
  }) : super(onPressed: onPressed, isSelected: isSelected);

  final UnitGroupModel unitGroup;

  @override
  Widget buildForGrid(BuildContext context) {
    return ConvertouchMenuGridItem(
      unitGroup,
      logo: _buildUnitGroupIconButton(),
      onPressed: onPressedFunc(context),
    );
  }

  @override
  Widget buildForList(BuildContext context) {
    return ConvertouchMenuListItem(
        unitGroup,
        logo: wrapLogo(_buildUnitGroupIconButton(), itemLogoWidth),
        onPressed: onPressedFunc(context)
    );
  }

  @override
  void Function()? onPressedFunc(BuildContext context) {
    return () {
      BlocProvider.of<UnitsMenuBloc>(context).add(FetchUnits(
          unitGroupId: unitGroup.id, navigationAction: NavigationAction.push));
    };
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