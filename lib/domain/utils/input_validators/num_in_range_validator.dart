import 'package:convertouch/domain/model/num_range.dart';
import 'package:convertouch/domain/utils/input_validators/input_validator.dart';
import 'package:convertouch/domain/utils/input_validators/model/input_validator_result.dart';

class NumInRangeValidator extends InputValidator {
  final NumRange numRange;

  const NumInRangeValidator(this.numRange);

  @override
  InputValidatorResult validate(String? input) {
    // if (input == null || numRange.contains(double.tryParse(input))) {
    //   return InputValidatorResult.failed(numRange.validationMessage);
    // }
    //
    // return const InputValidatorResult.successful();

    print("validator input = $input");

    if (input == null || input.length <= 2) {
      return InputValidatorResult.successful();
    }

    return InputValidatorResult.failed("Failed value $input");
  }
}
