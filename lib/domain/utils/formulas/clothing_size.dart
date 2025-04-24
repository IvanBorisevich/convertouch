import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/conversion_rule.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/model/value_range.dart';

class ClothingSizesTuple {
  final NumValueRange height;
  final Map<ClothingSizeCode, dynamic> sizesMap;

  const ClothingSizesTuple({
    required this.height,
    required this.sizesMap,
  });
}

const Map<Gender, Map<Garment, List<ClothingSizesTuple>>> clothingSizes = {
  Gender.male: {
    Garment.shirt: [
      ClothingSizesTuple(
        height: NumValueRange(0, 160),
        sizesMap: {
          ClothingSizeCode.inter: ClothingSizeInter.xxs,
          ClothingSizeCode.ru: 38,
          ClothingSizeCode.eu: 32,
          ClothingSizeCode.uk: 4,
          ClothingSizeCode.us: 0,
          ClothingSizeCode.it: 36,
          ClothingSizeCode.fr: 30,
          ClothingSizeCode.jp: 3,
        },
      ),
    ]
  },
};

final Map<String, ConversionRule> clothingSizeFormulas = {
  for (var code in ClothingSizeCode.values)
    code.name: ConversionRule.withParams(
      toBase: (x, ConversionParamSetValueModel params) {
        return _getInternationalClothingSize(
          inputSizeValue: x,
          inputSizeCode: code,
          params: params,
        );
      },
      fromBase: (inter, ConversionParamSetValueModel params) {
        return _getClothingSizeByCode(
          interSizeValue: ClothingSizeInter.valueOf(inter.raw),
          targetSizeCode: code,
          params: params,
        );
      },
    )
};

ValueModel? _getInternationalClothingSize({
  required ValueModel inputSizeValue,
  required ClothingSizeCode inputSizeCode,
  required ConversionParamSetValueModel params,
}) {
  Gender? gender = Gender.valueOf(params.getValue(genderParamName)?.raw);
  Garment? clothingType =
      Garment.valueOf(params.getValue(garmentParamName)?.raw);
  double? height = params.getValue(heightParamName)?.numVal;

  if (gender == null || clothingType == null || height == null) {
    return null;
  }

  dynamic inputSize = inputSizeCode == ClothingSizeCode.inter
      ? ClothingSizeInter.valueOf(inputSizeValue.raw)
      : inputSizeValue.numVal;

  var clothingSizeTuples = clothingSizes[gender]?[clothingType];
  var foundTuple = clothingSizeTuples?.firstWhereOrNull((sizesTuple) =>
      sizesTuple.height.contains(height) &&
      sizesTuple.sizesMap[inputSizeCode] == inputSize);

  ClothingSizeInter? interSize = foundTuple?.sizesMap[ClothingSizeCode.inter];

  return interSize != null ? ValueModel.str(interSize.name) : null;
}

ValueModel? _getClothingSizeByCode({
  required ClothingSizeInter? interSizeValue,
  required ClothingSizeCode targetSizeCode,
  required ConversionParamSetValueModel params,
}) {
  if (interSizeValue == null) {
    return null;
  }

  Gender? gender = Gender.valueOf(params.getValue(genderParamName)?.raw);
  Garment? clothingType =
      Garment.valueOf(params.getValue(garmentParamName)?.raw);
  double? height = params.getValue(heightParamName)?.numVal;

  if (gender == null || clothingType == null || height == null) {
    return null;
  }

  var clothingSizeTuples = clothingSizes[gender]?[clothingType];
  var foundTuple = clothingSizeTuples?.firstWhereOrNull((sizesTuple) =>
      sizesTuple.height.contains(height) &&
      sizesTuple.sizesMap[ClothingSizeCode.inter] == interSizeValue);

  dynamic foundSize = foundTuple?.sizesMap[targetSizeCode];

  if (foundSize is ClothingSizeInter) {
    return ValueModel.str(foundSize.name);
  }

  return ValueModel.numeric(foundSize);
}
