import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';

enum ConvertouchListType {
  gender(1, "Gender"),
  garment(2, "Garment");

  final int val;
  final String name;

  const ConvertouchListType(this.val, this.name);

  static ConvertouchListType? valueOf(int? value) {
    return values.firstWhereOrNull((element) => value == element.val);
  }

  List<T>? listValues<T extends Enum>() {
    return _listValueTypeNameToEnum[this] as List<T>;
  }
}

const Map<ConvertouchListType, List<Enum>> _listValueTypeNameToEnum = {
  ConvertouchListType.gender: Gender.values,
  ConvertouchListType.garment: Garment.values,
};