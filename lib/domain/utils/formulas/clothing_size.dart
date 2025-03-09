import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';
import 'package:convertouch/domain/model/conversion_param_set_values_model.dart';
import 'package:convertouch/domain/model/formula.dart';
import 'package:convertouch/domain/model/value_range.dart';

class ClothingSizesTuple {
  final NumValueRange height;

  final Map<ClothingSizeCode, String> sizesMap;

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
          ClothingSizeCode.inter: "XXS",
          ClothingSizeCode.ru: "38",
          ClothingSizeCode.eu: "32",
          ClothingSizeCode.uk: "4",
          ClothingSizeCode.us: "0",
          ClothingSizeCode.it: "36",
          ClothingSizeCode.fr: "30",
          ClothingSizeCode.jp: "3",
        },
      ),
    ]
  },
};

final Map<String, ConvertouchFormula<String, String>> clothingSizeFormulas = {
  for (var code in ClothingSizeCode.values)
    code.name: ConvertouchFormula.withParams(
      forward: (x, ConversionParamSetValuesModel params) {
        return _getInternationalClothingSize(
          inputSizeValue: x,
          inputSizeCode: code,
          params: params,
        );
      },
      reverse: (inter, ConversionParamSetValuesModel params) {
        return _getClothingSizeByCode(
          interSizeValue: inter,
          targetSizeCode: code,
          params: params,
        );
      },
    )
};

String _getInternationalClothingSize({
  required String inputSizeValue,
  required ClothingSizeCode inputSizeCode,
  required ConversionParamSetValuesModel params,
}) {
  Gender? gender = Gender.valueOf(params.values
      .firstWhere((e) => e.param.name == genderParamName)
      .value
      .raw);
  Garment? clothingType = Garment.valueOf(params.values
      .firstWhere((e) => e.param.name == garmentParamName)
      .value
      .raw);
  double? height = params.values
      .firstWhere((e) => e.param.name == heightParamName)
      .value
      .num;

  if (gender == null || clothingType == null || height == null) {
    return "";
  }

  var clothingSizeTuples = clothingSizes[gender]?[clothingType];
  var foundTuple = clothingSizeTuples?.firstWhereOrNull((sizesTuple) =>
      sizesTuple.height.contains(height) &&
      sizesTuple.sizesMap[inputSizeCode] == inputSizeValue);

  return foundTuple?.sizesMap[ClothingSizeCode.inter] ?? "";
}

String _getClothingSizeByCode({
  required String interSizeValue,
  required ClothingSizeCode targetSizeCode,
  required ConversionParamSetValuesModel params,
}) {
  Gender? gender = Gender.valueOf(params.values
      .firstWhere((e) => e.param.name == genderParamName)
      .value
      .raw);
  Garment? clothingType = Garment.valueOf(params.values
      .firstWhere((e) => e.param.name == garmentParamName)
      .value
      .raw);
  double? height = params.values
      .firstWhere((e) => e.param.name == heightParamName)
      .value
      .num;

  if (gender == null || clothingType == null || height == null) {
    return "";
  }

  var clothingSizeTuples = clothingSizes[gender]?[clothingType];
  var foundTuple = clothingSizeTuples?.firstWhereOrNull((sizesTuple) =>
      sizesTuple.height.contains(height) &&
      sizesTuple.sizesMap[ClothingSizeCode.inter] == interSizeValue);

  return foundTuple?.sizesMap[targetSizeCode] ?? "";
}
