import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:equatable/equatable.dart';

abstract class ConvertouchEvent extends Equatable {
  const ConvertouchEvent();

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
