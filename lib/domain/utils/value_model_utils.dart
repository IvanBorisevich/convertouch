import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';

class ValueModelUtils {
  const ValueModelUtils._();

  static ValueModel betweenOrNone({
    required double? rawValue,
    double? min,
    double? max,
  }) {
    return DoubleValueUtils.between(
      value: rawValue,
      min: min,
      max: max,
    )
        ? ValueModel.num(rawValue)
        : ValueModel.empty;
  }

  static ValueModel ofType(String? raw, ConvertouchValueType type) {
    switch (type) {
      case ConvertouchValueType.gender:
      case ConvertouchValueType.garment:
        return ValueModel.list(raw, type.listValueType);
      case ConvertouchValueType.text:
      case ConvertouchValueType.integerPositive:
      case ConvertouchValueType.integer:
      case ConvertouchValueType.decimalPositive:
      case ConvertouchValueType.decimal:
      default:
        return ValueModel.str(raw);
    }
  }
}
