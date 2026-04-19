import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/utils/input_validators/input_validator.dart';
import 'package:convertouch/domain/utils/input_validators/model/input_validator_result.dart';

class NumInRangeValidator extends InputValidator {
  final double? min;
  final double? max;

  const NumInRangeValidator(this.min, this.max);

  @override
  InputValidatorResult validate(String? input) {
    NumRange numRange = NumRange.withBoth(min, max);

    if (input == null || numRange.includesValue(double.tryParse(input))) {
      return const InputValidatorResult.successful();
    }

    return InputValidatorResult.failed(numRange.validationMessage);
  }
}
