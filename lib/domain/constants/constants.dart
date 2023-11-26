import 'package:convertouch/domain/constants/default_units.dart';

const String appName = "Convertouch";

const String iconAssetsPathPrefix = "assets/icons";

const String unitGroupDefaultIconName = "unit-group.png";
const String quicksandFontFamily = "Quicksand";

const String homePageId = '/';
const String unitsConversionPageId = "unitsConversionPage";
const String unitGroupsPageId = "unitGroupsPage";
const String unitsPageId = "unitsPage";
const String unitCreationPageId = "unitCreationPage";
const String unitGroupCreationPageId = "unitGroupCreationPage";

enum ItemType {
  unit,
  unitGroup,
  unitValue,
}

enum NavigationAction {
  pop,
  push,
  none,
}

enum ItemsViewMode {
  list,
  grid,
}

enum ConvertouchUITheme {
  light,
  dark,
}

const List<String> unitGroupsNoAddUnits = [
  temperatureGroup,
  currencyGroup,
];