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
        ? ValueModel.ofDouble(rawValue)
        : ValueModel.none;
  }

  static ValueModel coalesce({
    required ValueModel? v1,
    required ValueModel? v2,
  }) {
    if (v1?.exists == true) {
      return v1!;
    }

    if (v2?.exists == true) {
      return v2!;
    }

    return ValueModel.none;
  }
}
