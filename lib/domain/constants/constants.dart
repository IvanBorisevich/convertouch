import 'package:collection/collection.dart';

const appName = "Convertouch";
const unknownAppVersion = "Unknown";
const iconAssetsPathPrefix = "assets/icons";
const quicksandFontFamily = "Quicksand";
const baseUnitConversionRule = "Base unit";
const noConversionRule = "-";

abstract class GroupNames {
  const GroupNames._();

  static const angle = "Angle";
  static const area = "Area";
  static const clothesSize = "Clothes Size";
  static const currency = "Currency";
  static const length = "Length";
  static const mass = "Mass";
  static const pressure = "Pressure";
  static const ringSize = "Ring Size";
  static const speed = "Speed";
  static const temperature = "Temperature";
  static const volume = "Volume";
}

abstract class ParamSetNames {
  const ParamSetNames._();

  static const clothesSize = "Clothes Size";
  static const byHeight = "By Height";
  static const byDiameter = "By Diameter";
  static const byCircumference = "By Circumference";
  static const barbellWeight = "Barbell Weight";
  static const exchangeRate = "Exchange Rate";
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
  static const sourceOrBank = "Source / Bank";
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

abstract class IconKeys {
  const IconKeys._();

  static const angle = "angle";
  static const appLogo = "app_logo";
  static const area = "area";
  static const barbellWeightParams = "barbell_weight_params";
  static const circumference = "circumference";
  static const clothesSize = "clothes_size";
  static const clothesSizeParams = "clothes_size_params";
  static const currency = "currency";
  static const dataSource = "data_source";
  static const defaultGroup = "default_group";
  static const diameter = "diameter";
  static const exchangeRateParams = "exchange_rate_params";
  static const length = "length";
  static const mass = "mass";
  static const parameters = "parameters";
  static const pressure = "pressure";
  static const ringSize = "ring_size";
  static const speed = "speed";
  static const temperature = "temperature";
  static const volume = "volume";
}

const Map<String, String> idToIconName = {
  IconKeys.angle: "angle-group.svg",
  IconKeys.appLogo: "app-logo.svg",
  IconKeys.area: "area-group.svg",
  IconKeys.barbellWeightParams: "mass.svg",
  IconKeys.circumference: "circumference.svg",
  IconKeys.clothesSize: "clothes-size.svg",
  IconKeys.clothesSizeParams: "clothes-size.svg",
  IconKeys.currency: "currency-group.svg",
  IconKeys.dataSource: "data-source.svg",
  IconKeys.defaultGroup: "default-group.svg",
  IconKeys.diameter: "diameter.svg",
  IconKeys.exchangeRateParams: "chart.svg",
  IconKeys.length: "length-group.svg",
  IconKeys.mass: "mass.svg",
  IconKeys.parameters: "parameters.svg",
  IconKeys.pressure: "pressure-group.svg",
  IconKeys.ringSize: "ring-size-group.svg",
  IconKeys.speed: "speed-group.svg",
  IconKeys.temperature: "temperature-group.svg",
  IconKeys.volume: "volume-group.svg",
};

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
  errorPage;

  static PageName? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}

enum ItemType {
  unit,
  unitGroup,
  conversion,
  itemValue,
  conversionParamSet,
  conversionParamSetValue,
  conversionParam,
  job,
  dynamicValue,
  value,
  cron,
  dataSource,
}

enum BottomNavbarItem {
  home,
  settings,
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
  integerNonNegative(3, "Non-Negative Integer", defaultValueStr: "1", min: 0),
  decimal(4, "Decimal", defaultValueStr: "1"),
  decimalNonNegative(5, "Non-Negative Decimal", defaultValueStr: "1", min: 0),
  hexadecimal(6, "Hexadecimal", defaultValueStr: "1");

  final int id;
  final String name;
  final String? defaultValueStr;
  final double? min;

  const ConvertouchValueType(
    this.id,
    this.name, {
    this.defaultValueStr,
    this.min,
  });

  static ConvertouchValueType? valueOf(int? value) {
    return values.firstWhereOrNull((element) => value == element.id);
  }
}

enum ConvertouchListType {
  person(1, preselected: false),
  garment(2),
  clothesSizeInter(3),
  clothesSizeUs(4, listValuesType: ConvertouchValueType.integerNonNegative),
  clothesSizeJp(5),
  clothesSizeFr(6, listValuesType: ConvertouchValueType.integerNonNegative),
  clothesSizeEu(7, listValuesType: ConvertouchValueType.integerNonNegative),
  clothesSizeRu(8, listValuesType: ConvertouchValueType.integerNonNegative),
  clothesSizeIt(9, listValuesType: ConvertouchValueType.integerNonNegative),
  clothesSizeUk(10, listValuesType: ConvertouchValueType.integerNonNegative),
  clothesSizeDe(11, listValuesType: ConvertouchValueType.integerNonNegative),
  clothesSizeEs(12, listValuesType: ConvertouchValueType.integerNonNegative),
  ringSizeFr(13, listValuesType: ConvertouchValueType.decimalNonNegative),
  ringSizeRu(14, listValuesType: ConvertouchValueType.decimalNonNegative),
  ringSizeUs(15, listValuesType: ConvertouchValueType.decimalNonNegative),
  ringSizeIt(16, listValuesType: ConvertouchValueType.decimalNonNegative),
  barbellBarWeight(17, listValuesType: ConvertouchValueType.decimalNonNegative),
  ringSizeUk(18),
  ringSizeDe(19, listValuesType: ConvertouchValueType.integerNonNegative),
  ringSizeEs(20, listValuesType: ConvertouchValueType.decimalNonNegative),
  ringSizeJp(21, listValuesType: ConvertouchValueType.integerNonNegative),
  exchangeRateSource(
    22,
    fetchedViaApi: true,
    defaultIconUri: IconKeys.dataSource,
  ),
  clothesHeightRange(24),
  ringDiameterRange(25),
  ringCircumferenceRange(26),
  ;

  /// The id of the list type used for storing in db
  final int id;

  /// If true, the first element of list values is preselected by default,
  /// if the list is empty, no value is preselected
  final bool preselected;

  /// If true, list values of this type are fetched via API, not from db
  final bool fetchedViaApi;

  /// The type of list value itself - the keyboard type depends on it
  final ConvertouchValueType listValuesType;

  /// Default prefix icon uri for list values of this type
  final String? defaultIconUri;

  const ConvertouchListType(
    this.id, {
    this.listValuesType = ConvertouchValueType.text,
    this.fetchedViaApi = false,
    this.preselected = true,
    this.defaultIconUri,
  });

  static ConvertouchListType? valueOf(int? id) {
    return values.firstWhereOrNull((element) => id == element.id);
  }
}

enum FetchingStatus {
  success,
  loading,
  failure,
}

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
