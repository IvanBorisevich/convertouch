import 'package:collection/collection.dart';

const appName = "Convertouch";
const unknownAppVersion = "Unknown";
const iconAssetsPathPrefix = "assets/icons";
const quicksandFontFamily = "Quicksand";
const baseUnitConversionRule = "Base unit";
const noConversionRule = "-";

abstract class GroupNames {
  const GroupNames._();

  static const length = "Length";
  static const temperature = "Temperature";
  static const currency = "Currency";
  static const clothingSize = "Clothing Size";
  static const ringSize = "Ring Size";
  static const mass = "Mass";
}

abstract class ParamSetNames {
  const ParamSetNames._();

  static const byHeight = "By Height";
  static const byDiameter = "By Diameter";
  static const byCircumference = "By Circumference";
  static const barbellWeight = "Barbell Weight";
}

abstract class ParamNames {
  const ParamNames._();

  static const person = "Person";
  static const garment = "Garment";
  static const height = "Height";
  static const waist = "Waist";
  static const diameter = "Diameter";
  static const circumference = "Circumference";
  static const barWeight = "Bar Weight";
  static const oneSideWeight = "One Side Weight";
}

abstract class UnitCodes {
  const UnitCodes._();

  static const degreeCelsius = "°C";
  static const degreeFahrenheit = "°F";
  static const degreeKelvin = "K";
  static const degreeRankine = "°R";
  static const degreeDelisle = "°De";
  static const degreeNewton = "°N";
  static const degreeReaumur = "°Ré";
  static const degreeRomer = "°Rø";
}

abstract class IconNames {
  const IconNames._();

  static const oneWayConversion = "one_way_conversion.svg";
  static const parameters = "parameters.png";
}

enum SettingKey {
  sourceUnitId,
  sourceValue,
  targetUnitIds,
  conversionUnitGroupId,
  theme,
  unitGroupsViewMode,
  unitsViewMode,
  paramSetsViewMode,
  appVersion,
}

enum PageName {
  conversionGroupsPage,
  conversionPage,
  unitGroupsPageRegular,
  unitGroupsPageForUnitDetails,
  unitsPageRegular,
  unitsPageForConversion,
  unitsPageForConversionParams,
  unitsPageForUnitDetails,
  unitGroupDetailsPage,
  unitDetailsPage,
  paramSetsPage,
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
  conversionItemValue,
  conversionParamSet,
  conversionParamSetValue,
  conversionParam,
  job,
  dynamicValue,
  listValue,
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
  text(1, "Text"),
  integer(2, "Integer", defaultValueStr: "1"),
  integerPositive(3, "Positive Integer", defaultValueStr: "1"),
  decimal(4, "Decimal", defaultValueStr: "1"),
  decimalPositive(5, "Positive Decimal", defaultValueStr: "1"),
  hexadecimal(6, "Hexadecimal", defaultValueStr: "1");

  final int id;
  final String name;
  final String? defaultValueStr;

  const ConvertouchValueType(
    this.id,
    this.name, {
    this.defaultValueStr,
  });

  static ConvertouchValueType? valueOf(int? value) {
    return values.firstWhereOrNull((element) => value == element.id);
  }
}

enum ConvertouchListType {
  person(1, preselected: false),
  garment(2, preselected: false),
  clothingSizeInter(3),
  clothingSizeUs(4),
  clothingSizeJp(5),
  clothingSizeFr(6),
  clothingSizeEu(7),
  clothingSizeRu(8),
  clothingSizeIt(9),
  clothingSizeUk(10),
  clothingSizeDe(11),
  clothingSizeEs(12),
  ringSizeFr(13),
  ringSizeRu(14),
  ringSizeUs(15),
  ringSizeIt(16),
  barbellBarWeight(17),
  ringSizeUk(18),
  ringSizeDe(19),
  ringSizeEs(20),
  ringSizeJp(21),
  ;

  final int id;
  final bool preselected;

  const ConvertouchListType(
    this.id, {
    this.preselected = true,
  });

  static ConvertouchListType? valueOf(int? id) {
    return values.firstWhereOrNull((element) => id == element.id);
  }
}

enum FetchingStatus { success, failure }

enum ConvertouchSysAction {
  connection("SETTINGS");

  final String label;

  const ConvertouchSysAction(this.label);
}

enum CountryCode {
  inter("INT"),
  ru("RU"),
  eu("EU"),
  uk("UK"),
  us("US"),
  it("IT"),
  fr("FR"),
  jp("JP"),
  de("DE"),
  es("ES");

  final String name;

  const CountryCode(this.name);

  static CountryCode valueOf(String name) {
    return values.firstWhere((element) => name == element.name);
  }

  static String nameOf(CountryCode value) {
    return value.name;
  }
}
