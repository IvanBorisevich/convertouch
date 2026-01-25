import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_validation_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/input_validators/model/input_validator_result.dart';
import 'package:either_dart/either.dart';

class ValidateInputUseCase
    extends UseCase<InputValidationModel, InputValidatorResult> {
  const ValidateInputUseCase();

  @override
  Future<Either<ConvertouchException, InputValidatorResult>> execute(
    InputValidationModel input,
  ) async {
    bool successfulNoProceed = false;

    for (var validator in input.validators) {
      var validationResult = validator.validate(input.input);

      if (!validationResult.successful) {
        return Right(validationResult);
      } else if (!validationResult.proceedOnSuccess) {
        successfulNoProceed = true;
      }
    }

    return successfulNoProceed
        ? const Right(InputValidatorResult.successfulNoAfterActions())
        : const Right(InputValidatorResult.successful());
  }
}
