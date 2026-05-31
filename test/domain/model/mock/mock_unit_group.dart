import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

const lengthGroupId = 5;
const clothesSizeGroupId = 6;
const temperatureGroupId = 7;
const ringSizeGroupId = 8;
const massGroupId = 9;
const currencyGroupId = 10;

const mockUnitGroupWithoutUnits = UnitGroupModel(
  id: 0,
  name: "name",
  valueType: ConvertouchValueType.decimalNonNegative,
);

const mockUnitGroupWithOneBaseUnit = UnitGroupModel(
  id: 1,
  name: "name1",
  valueType: ConvertouchValueType.decimalNonNegative,
);

const mockUnitGroupWithMultipleBaseUnits = UnitGroupModel(
  id: 2,
  name: "name2",
  valueType: ConvertouchValueType.decimalNonNegative,
);

const mockUnitGroupWithOneBaseUnitOob = UnitGroupModel(
  id: 3,
  name: "name3",
  valueType: ConvertouchValueType.decimalNonNegative,
);

const mockUnitGroupWithMultipleBaseUnitsOob = UnitGroupModel(
  id: 4,
  name: "name4",
  valueType: ConvertouchValueType.decimalNonNegative,
);

const UnitGroupModel lengthGroup = UnitGroupModel(
  id: lengthGroupId,
  name: GroupNames.length,
  valueType: ConvertouchValueType.decimalNonNegative,
);

const UnitGroupModel clothesSizeGroup = UnitGroupModel(
  id: clothesSizeGroupId,
  name: GroupNames.clothesSize,
  valueType: ConvertouchValueType.integerNonNegative,
  conversionType: ConversionType.formula,
);

const UnitGroupModel temperatureGroup = UnitGroupModel(
  id: temperatureGroupId,
  name: GroupNames.temperature,
  valueType: ConvertouchValueType.decimal,
  conversionType: ConversionType.formula,
);

const UnitGroupModel ringSizeGroup = UnitGroupModel(
  id: ringSizeGroupId,
  name: GroupNames.ringSize,
  valueType: ConvertouchValueType.decimal,
  conversionType: ConversionType.formula,
);

const UnitGroupModel massGroup = UnitGroupModel(
  id: massGroupId,
  name: GroupNames.mass,
  valueType: ConvertouchValueType.decimal,
);

const UnitGroupModel currencyGroup = UnitGroupModel(
  id: currencyGroupId,
  name: GroupNames.currency,
  valueType: ConvertouchValueType.decimalNonNegative,
);
