import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_param_set_values_model.dart';
import 'package:convertouch/domain/model/formula.dart';
import 'package:convertouch/domain/model/value_range.dart';

const String genderParamName = "Gender";
const String clothingTypeParamName = "Clothing Type";
const String heightParamName = "Height";

enum Gender {
  man("Man"),
  woman("Woman");

  final String name;

  const Gender(this.name);

  static Gender? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}

enum ClothingType {
  shirt("Shirt"),
  trousers("Trousers");

  final String name;

  const ClothingType(this.name);

  static ClothingType? valueOf(String? name) {
    return values.firstWhereOrNull((element) => name == element.name);
  }
}

enum ClothingSizeCode {
  inter("INT"),
  ru("RU"),
  eu("EU"),
  uk("UK"),
  us("US"),
  it("IT"),
  fr("FR"),
  jp("JP");

  final String name;

  const ClothingSizeCode(this.name);
}

class ClothingSizesTuple {
  final NumValueRange height;

  final Map<ClothingSizeCode, String> sizesMap;

  const ClothingSizesTuple({
    required this.height,
    required this.sizesMap,
  });
}

const Map<Gender, Map<ClothingType, List<ClothingSizesTuple>>> clothingSizes = {
  Gender.man: {
    ClothingType.shirt: [
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
  Gender? gender =
      Gender.valueOf(params.paramValues[genderParamName]!.value.str);
  ClothingType? clothingType = ClothingType.valueOf(
      params.paramValues[clothingTypeParamName]!.value.str);
  double? height = params.paramValues[heightParamName]!.value.num;

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
  Gender? gender =
      Gender.valueOf(params.paramValues[genderParamName]!.value.str);
  ClothingType? clothingType = ClothingType.valueOf(
      params.paramValues[clothingTypeParamName]!.value.str);
  double? height = params.paramValues[heightParamName]!.value.num;

  if (gender == null || clothingType == null || height == null) {
    return "";
  }

  var clothingSizeTuples = clothingSizes[gender]?[clothingType];
  var foundTuple = clothingSizeTuples?.firstWhereOrNull((sizesTuple) =>
      sizesTuple.height.contains(height) &&
      sizesTuple.sizesMap[ClothingSizeCode.inter] == interSizeValue);

  return foundTuple?.sizesMap[targetSizeCode] ?? "";
}
