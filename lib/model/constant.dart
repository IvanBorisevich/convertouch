const String appName = "Convertouch";

const String iconPathPrefix = "assets/icons";
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

enum ActionTypeOnItemClick {
  markForSelection,
  select,
  fetch,
}