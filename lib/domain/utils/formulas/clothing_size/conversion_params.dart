import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/utils/formulas/clothing_size/formulas.dart';

const Map<String, ConversionParamSetModel> clothingSizeParamSetsMap = {
  clothingSizeGroup: ConversionParamSetModel(
    name: clothingSizeGroup,
    mandatory: true,
  ),
};

const Map<String, Map<String, ConversionParamModel>> clothingSizeParamsMap = {
  clothingSizeGroup: {
    genderParamName: ConversionParamModel<Gender>.listBased(
      name: genderParamName,
      possibleValues: Gender.values,
    ),
    clothingTypeParamName: ConversionParamModel<ClothingType>.listBased(
      name: clothingTypeParamName,
      possibleValues: ClothingType.values,
    ),
    heightParamName: ConversionParamModel.unitBased(
      name: heightParamName,
      unitGroupName: lengthGroup,
      possibleUnitCodes: [
        "cm",
        "m",
        "ft",
        "in",
      ],
    ),
  },
};
