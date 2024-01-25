const String appName = "Convertouch";
const String iconAssetsPathPrefix = "assets/icons";
const String unitGroupDefaultIconName = "unit-group.png";
const String quicksandFontFamily = "Quicksand";
const String sourceUnitIdKey = 'sourceUnitId';
const String sourceValueKey = 'sourceValue';
const String targetUnitIdsKey = 'targetUnitIds';
const String conversionUnitGroupIdKey = 'conversionUnitGroupId';


enum PageName {
  unitsConversionPage,
  unitGroupsPageRegular,
  unitGroupsPageForConversion,
  unitGroupsPageForUnitCreation,
  unitsPageRegular,
  unitsPageForConversion,
  unitsPageForUnitCreation,
  unitGroupCreationPage,
  unitCreationPage,
  refreshingJobsPage,
  refreshingJobDetailsPage,
}

enum ItemType {
  unit,
  unitGroup,
  conversionItem,
  refreshingJob,
  refreshableValue,
  cron,
  jobDataSource,
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

  static ConversionType valueOf(int? value) {
    if (value == null) {
      return ConversionType.static;
    }
    return values.firstWhere((element) => value == element.value);
  }
}

enum RefreshableDataPart {
  value(0),
  coefficient(1);

  final int val;

  const RefreshableDataPart(this.val);

  static RefreshableDataPart valueOf(int value) {
    return values.firstWhere((element) => value == element.val);
  }

  @override
  String toString() {
    return name;
  }
}

enum Cron {
  never(name: "Never", expression: null),
  everyHour(name: "Every hour", expression: "0 0 0/1 1/1 * ? *"),
  everyDay(name: "Every day", expression: "0 0 12 1/1 * ? *");

  final String name;
  final String? expression;

  const Cron({
    required this.name,
    required this.expression,
  });

  static Cron valueOf(String? name) {
    return values.firstWhere(
      (element) => name == element.name,
      orElse: () => Cron.never,
    );
  }
}
