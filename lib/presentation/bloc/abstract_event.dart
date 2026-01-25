import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:equatable/equatable.dart';

abstract class ConvertouchEvent extends Equatable {
  final void Function()? onComplete;
  final bool validateInput;
  final bool proceedAfterValidation;

  const ConvertouchEvent({
    this.onComplete,
    this.validateInput = true,
    this.proceedAfterValidation = true,
  });

  @override
  List<Object?> get props => [
    validateInput,
    proceedAfterValidation,
  ];
}

class ShowState<S extends ConvertouchState> extends ConvertouchEvent {
  final S state;

  const ShowState({
    required this.state,
  });

  E toType<E extends ConvertouchEvent>() {
    return this as E;
  }

  @override
  List<Object?> get props => [
    state,
  ];
}
