import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

class ShowParam extends ConvertouchEvent {
  final ConversionParamModel param;

  const ShowParam({
    required this.param,
    super.onComplete,
  });

  @override
  List<Object?> get props => [
        param,
      ];

  @override
  String toString() {
    return 'ShowParam{param: $param}';
  }
}

class SingleParamState extends ConvertouchState {
  final ConversionParamModel? param;

  const SingleParamState({
    required this.param,
  });

  @override
  List<Object?> get props => [
        param,
      ];

  @override
  String toString() {
    return 'SingleParamState{param: $param}';
  }
}

class SingleParamBloc
    extends ConvertouchBloc<ConvertouchEvent, SingleParamState> {
  SingleParamBloc() : super(const SingleParamState(param: null)) {
    on<ShowParam>((event, emit) {
      emit(
        SingleParamState(param: event.param),
      );

      event.onComplete?.call();
    });
  }
}
