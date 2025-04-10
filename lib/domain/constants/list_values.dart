import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';

final Map<ConvertouchListType, List<String>> listableSets = {
  ConvertouchListType.gender: Gender.values.map((e) => e.name).toList(),
  ConvertouchListType.garment: Garment.values.map((e) => e.name).toList(),
  ConvertouchListType.clothingSizeInter:
      ClothingSizeInter.values.map((e) => e.name).toList(),
  ConvertouchListType.clothingSizeUs:
      List.generate(12, (index) => "${(index + 1) * 2}"),
};
