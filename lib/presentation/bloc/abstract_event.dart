import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:equatable/equatable.dart';

abstract class ConvertouchEvent extends Equatable {
  final void Function({ConvertouchException? info})? onSuccess;
  final void Function(ConvertouchException)? onError;

  const ConvertouchEvent({
    this.onSuccess,
    this.onError,
  });

  @override
  List<Object?> get props => [];
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
