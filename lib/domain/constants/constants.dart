import 'package:collection/collection.dart';

const String appName = "Convertouch";
const String unknownAppVersion = "Unknown";
const String iconAssetsPathPrefix = "assets/icons";
const String quicksandFontFamily = "Quicksand";

const currencyGroup = "Currency";
const temperatureGroup = "Temperature";
const degreeCelsiusCode = "°C";
const degreeFahrenheitCode = "°F";
const degreeKelvinCode = "K";
const degreeRankineCode = "°R";
const degreeDelisleCode = "°De";
const degreeNewtonCode = "°N";
const degreeReaumurCode = "°Ré";
const degreeRomerCode = "°Rø";

const baseUnitConversionRule = "Base unit";
const noConversionRule = "-";

abstract class IconNames {
  const IconNames._();

  static const String oneWayConversion = "one_way_conversion.svg";
}

enum SettingKey {
  sourceUnitId,
  sourceValue,
  targetUnitIds,
  conversionUnitGroupId,
  theme,
  unitGroupsViewMode,
  unitsViewMode,
  appVersion,
}

enum PageName {
  conversionGroupsPage,
  conversionPage,
  unitGroupsPageRegular,
  unitGroupsPageForUnitDetails,
  unitsPageRegular,
  unitsPageForConversion,
  unitsPageForUnitDetails,
  unitGroupDetailsPage,
  unitDetailsPage,
  settingsPage,
  refreshingJobDetailsPage,
  errorPage;

  static PageName? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}

enum ItemType {
  unit,
  unitGroup,
  conversion,
  conversionItem,
  job,
  dynamicValue,
  cron,
  dataSource,
}

enum BottomNavbarItem {
  home,
  settings,
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
  static(0, "Static"),
  dynamic(1, "Dynamic"),
  formula(2, "Formula");

  final int value;
  final String name;

  const ConversionType(this.value, this.name);

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

  static Cron valueOf(dynamic value) {
    if (value is Cron) {
      return value;
    }

    return values.firstWhere(
      (element) => value == element.name,
      orElse: () => Cron.never,
    );
  }
}

enum ConvertouchValueType {
  text(1, "Any"),
  integer(2, "Integer"),
  integerPositive(3, "Positive Integer"),
  decimal(4, "Decimal"),
  decimalPositive(5, "Positive Decimal"),
  hexadecimal(6, "Hexadecimal");

  final int val;
  final String name;

  const ConvertouchValueType(this.val, this.name);

  static ConvertouchValueType? valueOf(int? value) {
    return values.firstWhereOrNull((element) => value == element.val);
  }
}

enum FetchingStatus { success, failure }
