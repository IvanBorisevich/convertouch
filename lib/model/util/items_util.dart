import 'package:convertouch/model/entity/id_name_model.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';

RegExp spaceOrEndOfWord = RegExp(r'\s+|$');
const int minWordLengthToWrap = 10;

int getLinesNumForGridItemNameWrapping(String gridItemName) {
  return gridItemName.indexOf(spaceOrEndOfWord) > minWordLengthToWrap ? 1 : 2;
}

UnitModel toUnit(IdNameModel itemModel) {
  if (itemModel is UnitModel) {
    return itemModel;
  }
  throw ArgumentError('Invalid type - it\'s not UnitModel');
}

UnitGroupModel toUnitGroup(IdNameModel itemModel) {
  if (itemModel is UnitGroupModel) {
    return itemModel;
  }
  throw ArgumentError('Invalid type - it\'s not UnitGroupModel');
}