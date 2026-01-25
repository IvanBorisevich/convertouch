import 'package:convertouch/domain/utils/input_validators/input_validator.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class InputValidationEvent extends ConvertouchEvent {
  const InputValidationEvent();
}

class ValidateInput extends InputValidationEvent {
  final String? input;
  final List<InputValidator> validators;
  final Future<void> Function()? onSuccess;

  const ValidateInput({
    required this.input,
    this.validators = const [],
    this.onSuccess,
  });

  ValidateInput copyWith({
    Future<void> Function()? onSuccess,
  }) {
    return ValidateInput(
      input: input,
      validators: validators,
      onSuccess: onSuccess ?? this.onSuccess,
    );
  }

  @override
  List<Object?> get props => [
        input,
      ];

  @override
  String toString() {
    return 'ValidateInput{input: $input}';
  }
}

class ResetValidation extends InputValidationEvent {
  const ResetValidation();

  @override
  String toString() {
    return 'ResetValidation{}';
  }
}
