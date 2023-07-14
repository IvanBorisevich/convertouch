import 'package:convertouch/presenter/states/units_conversion_states.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';


final RegExp _spaceOrEndOfWord = RegExp(r'\s+|$');
const int _minGridItemWordSizeToWrap = 10;


int getGridItemNameLinesNumToWrap(String gridItemName) {
  return gridItemName.indexOf(_spaceOrEndOfWord) > _minGridItemWordSizeToWrap
      ? 1
      : 2;
}

void updateSelectedUnitIds(final selectedUnitIds,
    UnitsMenuState unitSelected, UnitsConversionState unitsConverted) {
  if (unitSelected is UnitSelected) {
    int selectedUnitId = unitSelected.unitId;
    if (!selectedUnitIds.contains(selectedUnitId)) {
      selectedUnitIds.add(selectedUnitId);
    } else {
      selectedUnitIds.removeWhere((unitId) => unitId == selectedUnitId);
    }
  }

  List<int> conversionUnits = unitsConverted is ConversionInitialized
      ? unitsConverted.convertedUnitValues.map((e) => e.unit.id).toList()
      : [];
  List<int> allSelectedUnitIds =
      (conversionUnits + selectedUnitIds).toSet().toList();

  selectedUnitIds.clear();
  selectedUnitIds.addAll(allSelectedUnitIds);
}
