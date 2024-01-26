import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ConvertouchBloc<E extends ConvertouchEvent,
    S extends ConvertouchState> extends Bloc<E, S> {
  ConvertouchBloc(S initialState) : super(initialState) {
    on<E>((event, emit) {
      if (event is ShowState<S>) {
        emit(event.state);
      }
    });
  }
}
