import 'package:convertouch/domain/utils/input_validators/model/input_validator_result.dart';

abstract class InputValidator {
  const InputValidator();

  InputValidatorResult validate(String? input);
}

class SuccessValidator extends InputValidator {
  const SuccessValidator();

  @override
  InputValidatorResult validate(String? input) {
    return const InputValidatorResult.successful();
  }
}
