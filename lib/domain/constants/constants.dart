import 'package:convertouch/domain/constants/default_units.dart';

const String appName = "Convertouch";
const String iconAssetsPathPrefix = "assets/icons";
const String unitGroupDefaultIconName = "unit-group.png";
const String quicksandFontFamily = "Quicksand";

const String unitsConversionPage = "unitsConversionPage";
const String unitGroupsPageRegular = "unitGroupsPageRegular";
const String unitGroupsPageForConversion = "unitGroupsPageForConversion";
const String unitGroupsPageForUnitCreation = "unitGroupsPageForUnitCreation";
const String unitsPageRegular = "unitsPageRegular";
const String unitsPageForConversion = "unitsPageForConversion";
const String unitsPageForUnitCreation = "unitsPageForUnitCreation";
const String unitGroupCreationPage = "unitGroupCreationPage";
const String unitCreationPage = "unitCreationPage";

enum ItemType {
  unit,
  unitGroup,
  unitValue,
}

enum BottomNavbarItem {
  home,
  unitsMenu,
  more,
}

enum ItemsViewMode {
  list,
  grid,
}

enum ConvertouchUITheme {
  light,
  dark,
}

class ConversionType {
  static const int static = 0;
  static const int dynamic = 1;
  static const int formula = 2;
}

const List<String> notExtendableUnitGroups = [
  temperatureGroup,
  currencyGroup,
];
