import 'package:convertouch/domain/utils/input_validators/input_validator.dart';

class InputValidationModel {
  final String? input;
  final List<InputValidator> validators;

  const InputValidationModel({
    required this.input,
    this.validators = const [],
  });
}
