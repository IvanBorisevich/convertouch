import 'package:convertouch/domain/utils/input_validators/input_validator.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:flutter/foundation.dart';

abstract class InputValidationEvent extends ConvertouchEvent {
  final Key key;

  const InputValidationEvent({
    required this.key,
    super.onSuccess,
  });

  @override
  List<Object?> get props => [key];
}

class ValidateInput extends InputValidationEvent {
  final String input;
  final List<InputValidator> validators;

  const ValidateInput({
    required super.key,
    required this.input,
    required this.validators,
    super.onSuccess,
  });

  @override
  List<Object?> get props => [
        key,
        input,
      ];

  @override
  String toString() {
    return 'ValidateInput{'
        'key: $key, '
        'input: $input}';
  }
}

class ResetValidation extends InputValidationEvent {
  const ResetValidation({
    required super.key,
  });

  @override
  String toString() {
    return 'ResetValidation{key: $key}';
  }
}
