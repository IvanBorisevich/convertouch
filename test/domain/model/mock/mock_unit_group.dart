import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

const mockUnitGroupWithoutUnits = UnitGroupModel(
  id: 0,
  name: "name",
  valueType: ConvertouchValueType.decimalPositive,
);

const mockUnitGroupWithOneBaseUnit = UnitGroupModel(
  id: 1,
  name: "name1",
  valueType: ConvertouchValueType.decimalPositive,
);

const mockUnitGroupWithMultipleBaseUnits = UnitGroupModel(
  id: 2,
  name: "name2",
  valueType: ConvertouchValueType.decimalPositive,
);

const mockUnitGroupWithOneBaseUnitOob = UnitGroupModel(
  id: 3,
  name: "name3",
  valueType: ConvertouchValueType.decimalPositive,
);

const mockUnitGroupWithMultipleBaseUnitsOob = UnitGroupModel(
  id: 4,
  name: "name4",
  valueType: ConvertouchValueType.decimalPositive,
);

const UnitGroupModel lengthGroup = UnitGroupModel(
  id: 5,
  name: GroupNames.length,
  valueType: ConvertouchValueType.decimalPositive,
);

const UnitGroupModel clothingSizeGroup = UnitGroupModel(
  id: 6,
  name: GroupNames.clothingSize,
  valueType: ConvertouchValueType.integerPositive,
  conversionType: ConversionType.formula,
);

const UnitGroupModel temperatureGroup = UnitGroupModel(
  id: 7,
  name: GroupNames.temperature,
  valueType: ConvertouchValueType.decimal,
  conversionType: ConversionType.formula,
);

const UnitGroupModel ringSizeGroup = UnitGroupModel(
  id: 8,
  name: GroupNames.ringSize,
  valueType: ConvertouchValueType.decimal,
  conversionType: ConversionType.formula,
);
