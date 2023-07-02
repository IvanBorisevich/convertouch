const String appName = "Convertouch";

const String iconPathPrefix = "assets/icons";
const String unitGroupDefaultIconName = "unit-group.png";
const String quicksandFontFamily = "Quicksand";

const String homePageId = '/';
const String convertedItemsPageId = "convertedItemsPage";
const String unitGroupsPageId = "unitGroupsPage";
const String unitsPageId = "unitsPage";
const String unitCreationPageId = "unitCreationPage";
const String unitGroupCreationPageId = "unitGroupCreationPage";

const Map<String, String> pageTitles = {
  convertedItemsPageId: "Converted Items",
  unitGroupsPageId: "Unit Groups",
  unitsPageId: "Units",
  unitCreationPageId: "New Unit",
  unitGroupCreationPageId: "New Unit Group",
};

const Map<String, String> searchBarPlaceholders = {
  unitGroupsPageId: "Search unit groups...",
  unitsPageId: "Search units...",
};


enum ItemType {
  unit,
  unitGroup,
}

enum ConvertouchAction {
  back,
  menu,
  select,
  apply,
  remove,
  none
}

enum NavigationAction {
  push,
  pop,
  none
}