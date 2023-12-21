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
const String refreshingJobsPage = "refreshingJobsPage";

const String defaultCron = "0 0 12 1/1 * ? *";
const String defaultCronDescription = "Every day at 12:00 PM";

enum ItemType {
  unit,
  unitGroup,
  unitValue,
  refreshingJob,
}

enum BottomNavbarItem {
  home,
  unitsMenu,
  refreshableData,
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

enum RefreshableDataPart {
  value,
  coefficient;

  @override
  String toString() {
    return name;
  }
}
