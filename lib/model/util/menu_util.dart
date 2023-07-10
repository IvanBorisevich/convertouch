import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/item_model.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';

final RegExp _spaceOrEndOfWord = RegExp(r'\s+|$');
const int _minGridItemWordSizeToWrap = 10;

enum ItemsMenuViewMode {
  list(modeKey: 'listViewMode'),
  grid(modeKey: 'gridViewMode');

  final String modeKey;

  const ItemsMenuViewMode({required this.modeKey});

  ItemsMenuViewMode nextValue() {
    int currentValueIndex = values.indexOf(this);
    int nextValueIndex = (currentValueIndex + 1) % values.length;
    return values[nextValueIndex];
  }
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

int getGridItemNameLinesNumToWrap(String gridItemName) {
  return gridItemName.indexOf(_spaceOrEndOfWord) > _minGridItemWordSizeToWrap
      ? 1
      : 2;
}

String getIconPath(ItemModel itemModel) {
  return "$iconPathPrefix/${toUnitGroup(itemModel).iconName}";
}

String getInitialUnitAbbreviationFromName(String unitName) {
  return unitName.length > unitAbbreviationMaxLength
      ? unitName.substring(0, unitAbbreviationMaxLength)
      : unitName;
}
