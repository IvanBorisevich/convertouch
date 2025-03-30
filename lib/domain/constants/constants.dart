import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';
import 'package:convertouch/domain/model/list_value_type.dart';

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
  conversionParamSet,
  conversionParam,
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

enum ConvertouchListType {
  none(0, []),
  gender(1, Gender.values),
  garment(2, Garment.values),
  clothingSizeInter(3, ClothingSizeInter.values);

  final int val;
  final List<ListValueType> listValues;

  const ConvertouchListType(this.val, this.listValues);

  bool contains(String? value) {
    return listValues.any((listType) => listType.itemName == value);
  }

  static ConvertouchListType valueOf(int? value) {
    return values.firstWhereOrNull((element) => element.val == value) ?? none;
  }

  static ConvertouchListType byListValue(ListValueType listValue) {
    return values.firstWhereOrNull(
          (element) => element.listValues.contains(listValue),
        ) ??
        none;
  }
}

enum ConvertouchValueType {
  text(1, "Text"),
  integer(2, "Integer"),
  integerPositive(3, "Positive Integer"),
  decimal(4, "Decimal"),
  decimalPositive(5, "Positive Decimal"),
  hexadecimal(6, "Hexadecimal"),
  gender(7, "Gender", listType: ConvertouchListType.gender),
  garment(8, "Garment", listType: ConvertouchListType.garment),
  clothingSizeInter(9, "Clothing Size Inter",
      listType: ConvertouchListType.clothingSizeInter);

  final int val;
  final String name;
  final ConvertouchListType listType;

  const ConvertouchValueType(
    this.val,
    this.name, {
    this.listType = ConvertouchListType.none,
  });

  static ConvertouchValueType? valueOf(int? value) {
    return values.firstWhereOrNull((element) => value == element.val);
  }

  static ConvertouchValueType byListType(ConvertouchListType listType) {
    return values.firstWhere((e) => e.listType == listType);
  }

  List<String> listValues() {
    return listType.listValues.map((e) => e.itemName).toList();
  }

  bool get isList => listType != ConvertouchListType.none;
}

enum FetchingStatus { success, failure }

enum ConvertouchSysAction {
  connection("SETTINGS");

  final String label;

  const ConvertouchSysAction(this.label);
}
