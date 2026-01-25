import 'package:convertouch/domain/utils/input_validators/input_validator.dart';
import 'package:convertouch/domain/utils/input_validators/model/input_validator_result.dart';

class NumSignsValidator extends InputValidator {
  const NumSignsValidator();

  @override
  InputValidatorResult validate(String? input) {
    if (input == '.' || input == '-') {
      return const InputValidatorResult.successfulNoAfterActions();
    }

    return const InputValidatorResult.successful();
  }
}
