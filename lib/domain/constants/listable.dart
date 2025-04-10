import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';

class Listable<T> {
  final List<T> values;
  final String Function(T) valueNameFunc;

  const Listable({
    required this.values,
    required this.valueNameFunc,
  });
}

final Map<ConvertouchListType, Listable> listableSets = {
  ConvertouchListType.gender: Listable<Gender>(
    values: Gender.values,
    valueNameFunc: (value) => value.name,
  ),
  ConvertouchListType.garment: Listable<Garment>(
    values: Garment.values,
    valueNameFunc: (value) => value.name,
  ),
  ConvertouchListType.clothingSizeInter: Listable<ClothingSizeInter>(
    values: ClothingSizeInter.values,
    valueNameFunc: (value) => value.name,
  ),
  ConvertouchListType.clothingSizeUs: Listable<int>(
    values: List.generate(12, (index) => (index + 1) * 2),
    valueNameFunc: (value) => value.toString(),
  ),
};
