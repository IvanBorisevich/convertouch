import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';

final Map<String, UnitRule> clothingSizeFormulas = {
  for (var code in ClothingSizeCode.values)
    code.name: UnitRule.plain(
      xToBase: (x, {ConversionParamSetValueModel? params}) {
        return params != null
            ? _getInternationalClothingSize(
                inputSizeValue: x,
                inputSizeCode: code,
                params: params,
              )
            : null;
      },
      baseToY: (inter, {ConversionParamSetValueModel? params}) {
        return params != null
            ? _getClothingSizeByCode(
                interSizeValue: ClothingSizeInter.valueOf(inter.raw),
                targetSizeCode: code,
                params: params,
              )
            : null;
      },
    )
};

ValueModel? _getInternationalClothingSize({
  required ValueModel inputSizeValue,
  required ClothingSizeCode inputSizeCode,
  required ConversionParamSetValueModel params,
}) {
  dynamic inputSize = inputSizeCode == ClothingSizeCode.inter
      ? ClothingSizeInter.valueOf(inputSizeValue.raw)
      : inputSizeValue.numVal;

  SizesMap? sizeMap = _findMap(
    params: params,
    code: inputSizeCode,
    value: inputSize,
  );

  ClothingSizeInter? interSize = sizeMap?.sizeMap[ClothingSizeCode.inter];
  return ValueModel.any(interSize?.name);
}

ValueModel? _getClothingSizeByCode({
  required ClothingSizeInter? interSizeValue,
  required ClothingSizeCode targetSizeCode,
  required ConversionParamSetValueModel params,
}) {
  if (interSizeValue == null) {
    return null;
  }

  SizesMap? sizeMap = _findMap(
    params: params,
    code: ClothingSizeCode.inter,
    value: interSizeValue,
  );

  dynamic foundSize = sizeMap?.sizeMap[targetSizeCode];
  if (foundSize is ClothingSizeInter) {
    return ValueModel.str(foundSize.name);
  }

  return ValueModel.any(foundSize);
}

SizesMap? _findMap({
  required ConversionParamSetValueModel params,
  required ClothingSizeCode code,
  required dynamic value,
}) {
  Gender? gender = Gender.valueOf(params.getValue(genderParamName)?.raw);
  Garment? garment = Garment.valueOf(params.getValue(garmentParamName)?.raw);
  var heightParam = params.getParam(heightParamName);
  ValueModel? height = heightParam?.value ?? heightParam?.defaultValue;

  if (gender == null || garment == null || height == null) {
    return null;
  }

  var normalizedHeight = height.numVal! * heightParam!.unit!.coefficient!;
  var sizeMaps = clothingSizes[gender]?[garment] ?? [];

  if (sizeMaps.isEmpty) {
    return null;
  }

  return sizeMaps.firstWhereOrNull((m) =>
      m.height.contains(normalizedHeight, includeLeft: false) &&
      m.sizeMap[code] == value);
}
