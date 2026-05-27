import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

const mockUnit = UnitModel(
  id: 1,
  name: "name1",
  code: "n1",
  coefficient: 2,
  valueType: ConvertouchValueType.decimalNonNegative,
);

const mockOobUnit = UnitModel(
  id: 2,
  name: "name1oob",
  code: "n1o",
  coefficient: 2,
  valueType: ConvertouchValueType.decimalNonNegative,
  oob: true,
);

const mockBaseUnit = UnitModel(
  id: 3,
  name: "base1",
  code: "b1",
  coefficient: 1,
  valueType: ConvertouchValueType.decimalNonNegative,
);

const mockOobBaseUnit = UnitModel(
  id: 4,
  name: "base1oob",
  code: "b1o",
  coefficient: 1,
  valueType: ConvertouchValueType.decimalNonNegative,
  oob: true,
);

const mockBaseUnit2 = UnitModel(
  id: 5,
  name: "base2",
  code: "b2",
  coefficient: 1,
  valueType: ConvertouchValueType.decimalNonNegative,
);

const mockOobBaseUnit2 = UnitModel(
  id: 6,
  name: "base2oob",
  code: "b2o",
  coefficient: 1,
  valueType: ConvertouchValueType.decimalNonNegative,
  oob: true,
);

const UnitModel centimeter = UnitModel(
  id: 1,
  name: "Centimeter",
  code: "cm",
  valueType: ConvertouchValueType.decimalNonNegative,
  minValue: ValueModel.zero,
  coefficient: 0.01,
  unitGroupId: 5,
);

const UnitModel millimeter = UnitModel(
  id: 2,
  name: "Millimeter",
  code: "mm",
  valueType: ConvertouchValueType.decimalNonNegative,
  minValue: ValueModel.zero,
  coefficient: 0.001,
  unitGroupId: 5,
);

const UnitModel decimeter = UnitModel(
  id: 3,
  name: "Decimeter",
  code: "dm",
  valueType: ConvertouchValueType.decimalNonNegative,
  minValue: ValueModel.zero,
  coefficient: 0.1,
  unitGroupId: 5,
);

const UnitModel meter = UnitModel(
  id: 4,
  name: 'Meter',
  code: 'm',
  valueType: ConvertouchValueType.decimalNonNegative,
  minValue: ValueModel.zero,
  coefficient: 1,
  unitGroupId: 5,
);

const UnitModel kilometer = UnitModel(
  id: 5,
  name: "Kilometer",
  code: "km",
  valueType: ConvertouchValueType.decimalNonNegative,
  minValue: ValueModel.zero,
  coefficient: 1000,
  unitGroupId: 5,
);

const UnitModel europeanClothSize = UnitModel(
  id: 6,
  name: "Europe",
  code: "EU",
  valueType: ConvertouchValueType.integerNonNegative,
  listType: ConvertouchListType.clothesSizeEu,
  unitGroupId: 6,
);

const UnitModel japanClothSize = UnitModel(
  id: 7,
  name: "Japan",
  code: "JP",
  valueType: ConvertouchValueType.text,
  listType: ConvertouchListType.clothesSizeJp,
  unitGroupId: 6,
);

const UnitModel italianClothSize = UnitModel(
  id: 8,
  name: "Italia",
  code: "IT",
  valueType: ConvertouchValueType.integerNonNegative,
  listType: ConvertouchListType.clothesSizeIt,
  unitGroupId: 6,
);

const UnitModel usaClothSize = UnitModel(
  id: 9,
  name: 'Clothes Size US',
  code: 'US',
  valueType: ConvertouchValueType.decimalNonNegative,
  listType: ConvertouchListType.clothesSizeUs,
  unitGroupId: 6,
);

const UnitModel usaRingSize = UnitModel(
  id: 10,
  name: 'Ring Size US',
  code: 'US',
  valueType: ConvertouchValueType.decimalNonNegative,
  listType: ConvertouchListType.ringSizeUs,
  unitGroupId: 8,
);

const UnitModel frRingSize = UnitModel(
  id: 11,
  name: 'Ring Size FR',
  code: 'FR',
  valueType: ConvertouchValueType.decimalNonNegative,
  listType: ConvertouchListType.ringSizeFr,
  unitGroupId: 8,
);

const UnitModel ruRingSize = UnitModel(
  id: 12,
  name: 'Ring Size RU',
  code: 'RU',
  valueType: ConvertouchValueType.decimalNonNegative,
  listType: ConvertouchListType.ringSizeRu,
  unitGroupId: 8,
);

const UnitModel kilogram = UnitModel(
  id: 13,
  name: "Kilogram",
  code: "kg",
  valueType: ConvertouchValueType.decimalNonNegative,
  minValue: ValueModel.zero,
  coefficient: 1,
  unitGroupId: 9,
);

const UnitModel pound = UnitModel(
  id: 14,
  name: "Pound",
  code: "lbs.",
  valueType: ConvertouchValueType.decimalNonNegative,
  minValue: ValueModel.zero,
  coefficient: 0.45359237,
  unitGroupId: 9,
);

const UnitModel spainClothSize = UnitModel(
  id: 15,
  name: "Spain",
  code: "ES",
  valueType: ConvertouchValueType.integerNonNegative,
  listType: ConvertouchListType.clothesSizeEs,
  unitGroupId: 6,
);

const UnitModel germanyClothSize = UnitModel(
  id: 16,
  name: "Germany",
  code: "DE",
  valueType: ConvertouchValueType.integerNonNegative,
  listType: ConvertouchListType.clothesSizeDe,
  unitGroupId: 6,
);

const UnitModel deRingSize = UnitModel(
  id: 17,
  name: 'Germany',
  code: 'DE',
  valueType: ConvertouchValueType.decimalNonNegative,
  listType: ConvertouchListType.ringSizeDe,
  unitGroupId: 8,
);

const UnitModel esRingSize = UnitModel(
  id: 18,
  name: 'Spain',
  code: 'ES',
  valueType: ConvertouchValueType.decimalNonNegative,
  listType: ConvertouchListType.ringSizeEs,
  unitGroupId: 8,
);

const UnitModel ton = UnitModel(
  id: 19,
  name: "Ton",
  code: "T",
  valueType: ConvertouchValueType.decimalNonNegative,
  minValue: ValueModel.zero,
  coefficient: 1000,
  unitGroupId: 9,
);

const UnitModel degreeFahrenheit = UnitModel(
  id: 20,
  name: "Fahrenheit",
  code: UnitCodes.degreeFahrenheit,
  valueType: ConvertouchValueType.decimal,
  unitGroupId: 7,
);

const UnitModel degreeKelvin = UnitModel(
  id: 21,
  name: "Kelvin",
  code: UnitCodes.degreeKelvin,
  valueType: ConvertouchValueType.decimal,
  unitGroupId: 7,
);

const UnitModel ruClothesSize = UnitModel(
  id: 22,
  name: "Clothes Size RU",
  code: 'RU',
  valueType: ConvertouchValueType.decimalNonNegative,
  listType: ConvertouchListType.clothesSizeRu,
  unitGroupId: 6,
);

const UnitModel usd = UnitModel(
  id: 23,
  name: "Dollar US",
  code: 'USD',
  valueType: ConvertouchValueType.decimalNonNegative,
  unitGroupId: 10,
);

const UnitModel eur = UnitModel(
  id: 24,
  name: "Euro",
  code: 'EUR',
  valueType: ConvertouchValueType.decimalNonNegative,
  unitGroupId: 10,
);