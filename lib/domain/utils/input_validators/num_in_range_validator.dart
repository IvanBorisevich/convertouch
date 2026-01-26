import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/utils/input_validators/input_validator.dart';
import 'package:convertouch/domain/utils/input_validators/model/input_validator_result.dart';

class NumInRangeValidator extends InputValidator {
  final double? min;
  final double? max;

  const NumInRangeValidator(this.min, this.max);

  @override
  InputValidatorResult validate(String? input) {
    NumRange numRange = NumRange.closed(min, max);

    if (input == null || numRange.contains(double.tryParse(input))) {
      return InputValidatorResult.failed(numRange.validationMessage);
    }

    return const InputValidatorResult.successful();
  }
}
