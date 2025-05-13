import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';

import 'mock_unit.dart';

const clothingSizeParamSet = ConversionParamSetModel(
  id: 1,
  name: ParamSetNames.byHeight,
  mandatory: true,
  groupId: -1,
);

const ringSizeByDiameterParamSet = ConversionParamSetModel(
  id: 2,
  name: ParamSetNames.byDiameter,
  mandatory: false,
  groupId: -1,
);

const ringSizeByCircumferenceParamSet = ConversionParamSetModel(
  id: 3,
  name: ParamSetNames.byCircumference,
  mandatory: false,
  groupId: -1,
);

const barbellWeightParamSet = ConversionParamSetModel(
  id: 4,
  name: ParamSetNames.barbellWeight,
  mandatory: false,
  groupId: -1,
);

const genderParam = ConversionParamModel(
  id: 1,
  name: ParamNames.gender,
  paramSetId: 1,
  valueType: ConvertouchValueType.text,
  listType: ConvertouchListType.gender,
);

const garmentParam = ConversionParamModel(
  id: 2,
  name: ParamNames.garment,
  paramSetId: 1,
  valueType: ConvertouchValueType.text,
  listType: ConvertouchListType.garment,
);

const heightParam = ConversionParamModel(
  id: 3,
  name: ParamNames.height,
  unitGroupId: 1,
  valueType: ConvertouchValueType.decimalPositive,
  defaultUnit: centimeter,
  paramSetId: 1,
);

const diameterParam = ConversionParamModel(
  id: 4,
  name: ParamNames.diameter,
  unitGroupId: 2,
  valueType: ConvertouchValueType.decimalPositive,
  defaultUnit: millimeter,
  calculable: true,
  paramSetId: 2,
);

const circumferenceParam = ConversionParamModel(
  id: 5,
  name: ParamNames.circumference,
  unitGroupId: 2,
  valueType: ConvertouchValueType.decimalPositive,
  defaultUnit: millimeter,
  calculable: true,
  paramSetId: 3,
);

const barWeightParam = ConversionParamModel(
  id: 5,
  name: ParamNames.barWeight,
  unitGroupId: 3,
  valueType: ConvertouchValueType.decimalPositive,
  listType: ConvertouchListType.barbellBarWeight,
  defaultUnit: kilogram,
  calculable: false,
  paramSetId: 4,
);

const oneSideWeightParam = ConversionParamModel(
  id: 6,
  name: ParamNames.oneSideWeight,
  unitGroupId: 3,
  valueType: ConvertouchValueType.decimalPositive,
  defaultUnit: kilogram,
  calculable: true,
  paramSetId: 4,
);
