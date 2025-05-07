import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';

const clothingSizeParamSet = ConversionParamSetModel(
  id: 1,
  name: ParamSetNames.byHeight,
  mandatory: true,
  groupId: -1,
);

const ringSizeByDiameterParamSet = ConversionParamSetModel(
  id: 2,
  name: "By Diameter",
  mandatory: false,
  groupId: -1,
);

const ringSizeByCircumferenceParamSet = ConversionParamSetModel(
  id: 3,
  name: "By Circumference",
  mandatory: false,
  groupId: -1,
);

const genderParam = ConversionParamModel(
  id: 1,
  name: "Gender",
  paramSetId: 1,
  valueType: ConvertouchValueType.text,
  listType: ConvertouchListType.gender,
);

const garmentParam = ConversionParamModel(
  id: 2,
  name: "Garment",
  paramSetId: 1,
  valueType: ConvertouchValueType.text,
  listType: ConvertouchListType.garment,
);

const heightParam = ConversionParamModel(
  id: 3,
  name: 'Height',
  unitGroupId: 1,
  valueType: ConvertouchValueType.decimalPositive,
  paramSetId: 1,
);

const diameterParam = ConversionParamModel(
  id: 4,
  name: 'Diameter',
  unitGroupId: 2,
  valueType: ConvertouchValueType.decimalPositive,
  paramSetId: 2,
);

const circumferenceParam = ConversionParamModel(
  id: 5,
  name: 'Circumference',
  unitGroupId: 2,
  valueType: ConvertouchValueType.decimalPositive,
  paramSetId: 3,
);
