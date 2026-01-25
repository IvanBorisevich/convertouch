import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class InputValidationState extends ConvertouchState {
  const InputValidationState();
}

class InputValidationSuccess extends InputValidationState {
  const InputValidationSuccess();

  @override
  String toString() {
    return 'InputValidationSuccess{}';
  }
}

class InputValidationErrorState extends InputValidationState {
  final String errorMessage;

  const InputValidationErrorState(this.errorMessage);

  @override
  List<Object?> get props => [
    errorMessage,
  ];

  @override
  String toString() {
    return 'InputValidationErrorState{errorMessage: $errorMessage}';
  }
}
