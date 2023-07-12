import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/view/items_view/item/unit_group_item.dart';
import 'package:convertouch/view/items_view/item/unit_item.dart';
import 'package:convertouch/view/items_view/item/unit_value_item.dart';
import 'package:flutter/material.dart';

abstract class ConvertouchItem {
  const ConvertouchItem({
    this.onPressed
  });

  final void Function()? onPressed;

  factory ConvertouchItem.createItem(ItemModel item) {
    switch (item.itemType) {
      case ItemType.unitGroup:
        return ConvertouchUnitGroupItem(item as UnitGroupModel);
      case ItemType.unit:
        return ConvertouchUnitItem(item as UnitModel);
      case ItemType.unitValue:
        return ConvertouchUnitValueItem(item as UnitValueModel);
    }
  }

  Widget buildForList(BuildContext context);

  Widget buildForGrid(BuildContext context);

  void onClickByDefault(BuildContext context);

  void Function()? onPressedFunc(BuildContext context) {
    return onPressed ?? () {
      onClickByDefault(context);
    };
  }

  Widget wrapLogo(Widget logo, double wrapWidth) {
    return Container(
      width: wrapWidth,
      decoration: const BoxDecoration(
        color: Color(0x00FFFFFF),
      ),
      child: logo,
    );
  }
}

final RegExp _spaceOrEndOfWord = RegExp(r'\s+|$');
const int _minGridItemWordSizeToWrap = 10;

int getGridItemNameLinesNumToWrap(String gridItemName) {
  return gridItemName.indexOf(_spaceOrEndOfWord) > _minGridItemWordSizeToWrap
      ? 1
      : 2;
}