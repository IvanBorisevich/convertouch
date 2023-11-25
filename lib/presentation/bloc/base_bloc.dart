import 'package:convertouch/presentation/bloc/base_event.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';
import 'package:convertouch/presentation/bloc/unit_conversions_page/units_conversion_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertouchPageBloc extends Bloc<ConvertouchPageEvent, ConvertouchPageState> {
  ConvertouchPageBloc() : super(const UnitsConversionInitState());

  @override
  Stream<ConvertouchPageState> mapEventToState(ConvertouchPageEvent event) async* {
    yield const UnitsConversionInitState();
  }
}