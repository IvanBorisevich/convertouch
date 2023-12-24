import 'package:convertouch/domain/model/input/abstract_event.dart';
import 'package:convertouch/domain/model/output/abstract_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ConvertouchBloc<E extends ConvertouchEvent,
    S extends ConvertouchState> extends Bloc<E, S> {
  ConvertouchBloc(S initialState) : super(initialState);

  @override
  Stream<S> mapEventToState(E event) async* {}
}
