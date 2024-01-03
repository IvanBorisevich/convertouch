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

const String sourceUnitIdKey = 'sourceUnitId';
const String sourceValueKey = 'sourceValue';
const String targetUnitIdsKey = 'targetUnitIds';
const String conversionUnitGroupIdKey = 'conversionUnitGroupId';

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

enum ConversionType {
  static(0),
  dynamic(1),
  formula(2);

  final int value;
  const ConversionType(this.value);
}

enum DataRefreshingStatus {
  off(0),
  on(1);

  final int value;
  const DataRefreshingStatus(this.value);
}

enum RefreshableDataPart {
  value(0),
  coefficient(1);

  final int val;
  const RefreshableDataPart(this.val);

  @override
  String toString() {
    return name;
  }
}
