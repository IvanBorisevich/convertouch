import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';

final RegExp _spaceOrEndOfWord = RegExp(r'\s+|$');
const int _minGridItemWordSizeToWrap = 10;

UnitModel toUnit(ItemModel itemModel) {
  if (itemModel is UnitModel) {
    return itemModel;
  }
  throw ArgumentError('Invalid type - it\'s not UnitModel');
}

UnitGroupModel toUnitGroup(ItemModel itemModel) {
  if (itemModel is UnitGroupModel) {
    return itemModel;
  }
  throw ArgumentError('Invalid type - it\'s not UnitGroupModel');
}

int getGridItemNameLinesNumToWrap(String gridItemName) {
  return gridItemName.indexOf(_spaceOrEndOfWord) > _minGridItemWordSizeToWrap
      ? 1
      : 2;
}

String getIconPath(ItemModel itemModel) {
  return "$iconPathPrefix/${toUnitGroup(itemModel).iconName}";
}