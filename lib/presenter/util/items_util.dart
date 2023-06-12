import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';

RegExp spaceOrEndOfWord = RegExp(r'\s+|$');
const int minWordLengthToWrapInGridItem = 10;

int getLinesNumForGridItemNameWrapping(String gridItemName) {
  return gridItemName.indexOf(spaceOrEndOfWord) > minWordLengthToWrapInGridItem
      ? 1
      : 2;
}

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
