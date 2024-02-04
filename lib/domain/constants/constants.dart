import 'package:collection/collection.dart';

const String appName = "Convertouch";
const String iconAssetsPathPrefix = "assets/icons";
const String unitGroupDefaultIconName = "unit-group.png";
const String quicksandFontFamily = "Quicksand";

abstract class SettingKeys {
  const SettingKeys._();

  static const String sourceUnitId = 'sourceUnitId';
  static const String sourceValue = 'sourceValue';
  static const String targetUnitIds = 'targetUnitIds';
  static const String conversionUnitGroupId = 'conversionUnitGroupId';
  static const String theme = "theme";
  static const String unitGroupsViewMode = "unitGroupsViewMode";
  static const String unitsViewMode = "unitsViewMode";
}

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
  settingsPage,
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
  settings,
  more,
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

enum ConversionType {
  static(0),
  dynamic(1),
  formula(2);

  final int value;

  const ConversionType(this.value);

  static ConversionType valueOf(int? value) {
    return values.firstWhereOrNull((element) => value == element.value) ??
        ConversionType.static;
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
