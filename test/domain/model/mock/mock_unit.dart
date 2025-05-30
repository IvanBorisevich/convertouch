import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

const mockUnit = UnitModel(
  id: 1,
  name: "name1",
  code: "n1",
  coefficient: 2,
  valueType: ConvertouchValueType.decimalPositive,
);

const mockOobUnit = UnitModel(
  id: 2,
  name: "name1oob",
  code: "n1o",
  coefficient: 2,
  valueType: ConvertouchValueType.decimalPositive,
  oob: true,
);

const mockBaseUnit = UnitModel(
  id: 3,
  name: "base1",
  code: "b1",
  coefficient: 1,
  valueType: ConvertouchValueType.decimalPositive,
);

const mockOobBaseUnit = UnitModel(
  id: 4,
  name: "base1oob",
  code: "b1o",
  coefficient: 1,
  valueType: ConvertouchValueType.decimalPositive,
  oob: true,
);

const mockBaseUnit2 = UnitModel(
  id: 5,
  name: "base2",
  code: "b2",
  coefficient: 1,
  valueType: ConvertouchValueType.decimalPositive,
);

const mockOobBaseUnit2 = UnitModel(
  id: 6,
  name: "base2oob",
  code: "b2o",
  coefficient: 1,
  valueType: ConvertouchValueType.decimalPositive,
  oob: true,
);

const UnitModel centimeter = UnitModel(
  id: 1,
  name: "Centimeter",
  code: "cm",
  valueType: ConvertouchValueType.decimalPositive,
  minValue: ValueModel.zero,
  coefficient: 0.01,
);

const UnitModel millimeter = UnitModel(
  id: 2,
  name: "Millimeter",
  code: "mm",
  valueType: ConvertouchValueType.decimalPositive,
  minValue: ValueModel.zero,
  coefficient: 0.001,
);

const UnitModel decimeter = UnitModel(
  id: 3,
  name: "Decimeter",
  code: "dm",
  valueType: ConvertouchValueType.decimalPositive,
  minValue: ValueModel.zero,
  coefficient: 0.1,
);

const UnitModel meter = UnitModel(
  id: 4,
  name: 'Meter',
  code: 'm',
  valueType: ConvertouchValueType.decimalPositive,
  minValue: ValueModel.zero,
  coefficient: 1,
);

const UnitModel kilometer = UnitModel(
  id: 5,
  name: "Kilometer",
  code: "km",
  valueType: ConvertouchValueType.decimalPositive,
  minValue: ValueModel.zero,
  coefficient: 1000,
);

const UnitModel europeanClothSize = UnitModel(
  id: 6,
  name: "Europe",
  code: "EU",
  valueType: ConvertouchValueType.integerPositive,
  listType: ConvertouchListType.clothesSizeEu,
);

const UnitModel japanClothSize = UnitModel(
  id: 7,
  name: "Japan",
  code: "JP",
  valueType: ConvertouchValueType.text,
  listType: ConvertouchListType.clothesSizeJp,
);

const UnitModel italianClothSize = UnitModel(
  id: 8,
  name: "Italia",
  code: "IT",
  valueType: ConvertouchValueType.integerPositive,
  listType: ConvertouchListType.clothesSizeIt,
);

const UnitModel usaClothSize = UnitModel(
  id: 9,
  name: 'Clothes Size US',
  code: 'US',
  valueType: ConvertouchValueType.decimalPositive,
  listType: ConvertouchListType.clothesSizeUs,
);

const UnitModel usaRingSize = UnitModel(
  id: 10,
  name: 'Ring Size US',
  code: 'US',
  valueType: ConvertouchValueType.decimalPositive,
  listType: ConvertouchListType.ringSizeUs,
);

const UnitModel frRingSize = UnitModel(
  id: 11,
  name: 'Ring Size FR',
  code: 'FR',
  valueType: ConvertouchValueType.decimalPositive,
  listType: ConvertouchListType.ringSizeFr,
);

const UnitModel ruRingSize = UnitModel(
  id: 12,
  name: 'Ring Size RU',
  code: 'RU',
  valueType: ConvertouchValueType.decimalPositive,
  listType: ConvertouchListType.ringSizeRu,
);

const UnitModel kilogram = UnitModel(
  id: 13,
  name: "Kilogram",
  code: "kg",
  valueType: ConvertouchValueType.decimalPositive,
  minValue: ValueModel.zero,
  coefficient: 1,
);

const UnitModel pound = UnitModel(
  id: 14,
  name: "Pound",
  code: "lbs.",
  valueType: ConvertouchValueType.decimalPositive,
  minValue: ValueModel.zero,
  coefficient: 0.45359237,
);
