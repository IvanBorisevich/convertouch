import 'package:collection/collection.dart';

enum SettingKey {
  theme,
  unitGroupsViewMode,
  unitsViewMode,
  paramSetsViewMode,
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
  showUnitInfo("Show Unit Info"),
  selectReplacingUnit("Select Replacing Unit");

  final String value;

  const UnitTapAction(this.value);
}

enum RecalculationOnUnitReplace {
  currentValue("Recalculate Current Value"),
  otherValues("Recalculate Other Values");

  final String value;

  const RecalculationOnUnitReplace(this.value);
}