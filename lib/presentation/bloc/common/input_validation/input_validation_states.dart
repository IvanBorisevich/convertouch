import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:flutter/foundation.dart';

abstract class InputValidationState extends ConvertouchState {
  final Key? key;

  const InputValidationState({
    required this.key,
  });

  @override
  List<Object?> get props => [key];
}

class InputValidationSuccess extends InputValidationState {
  const InputValidationSuccess({
    required super.key,
  });

  @override
  String toString() {
    return 'InputValidationSuccess{key: $key}';
  }
}

class InputValidationErrorState extends InputValidationState {
  final String errorMessage;

  const InputValidationErrorState({
    required super.key,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [
        key,
        errorMessage,
      ];

  @override
  String toString() {
    return 'InputValidationErrorState{'
        'key: $key, '
        'errorMessage: $errorMessage}';
  }
}
