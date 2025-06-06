import 'package:collection/collection.dart';

enum SettingKey {
  theme,
  unitGroupsViewMode,
  unitsViewMode,
  paramSetsViewMode,
  conversionUnitTapAction,
  recalculationOnUnitChange,
  appVersion,
}

enum ConvertouchUITheme {
  light("Light"),
  dark("Dark");

  final String value;

  const ConvertouchUITheme(this.value);

  static ConvertouchUITheme valueOf(String? value) {
    return values.firstWhereOrNull((element) => value == element.value) ??
        ConvertouchUITheme.light;
  }
}

enum ItemsViewMode {
  list("List"),
  grid("Grid");

  final String value;

  const ItemsViewMode(this.value);

  static ItemsViewMode valueOf(String? value) {
    return values.firstWhereOrNull((element) => value == element.value) ?? grid;
  }

  ItemsViewMode get next {
    switch (this) {
      case list:
        return grid;
      case grid:
        return list;
    }
  }
}

enum UnitTapAction {
  selectReplacingUnit(1, "Select Replacing Unit"),
  showUnitInfo(2, "Show Unit Info");

  final int id;
  final String value;

  const UnitTapAction(this.id, this.value);

  static UnitTapAction valueOf(int? id) {
    return values.firstWhereOrNull((element) => id == element.id) ??
        selectReplacingUnit;
  }
}

enum RecalculationOnUnitChange {
  otherValues(1, "Recalculate Other Values"),
  currentValue(2, "Recalculate Current Value");

  final int id;
  final String value;

  const RecalculationOnUnitChange(this.id, this.value);

  static RecalculationOnUnitChange valueOf(int? id) {
    return values.firstWhereOrNull((element) => id == element.id) ??
        otherValues;
  }
}
