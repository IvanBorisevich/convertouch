import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';

class ValueModelUtils {
  const ValueModelUtils._();

  static ValueModel betweenOrUndefined({
    required double? rawValue,
    double? min,
    double? max,
  }) {
    return DoubleValueUtils.between(
      value: rawValue,
      min: min,
      max: max,
    )
        ? ValueModel.ofDouble(rawValue)
        : ValueModel.undefined;
  }
}
