import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionItemBloc
    extends ConvertouchBloc<ConversionItemEvent, ConversionItemState> {
  ConversionItemBloc()
      : super(const ConversionItemState(id: null, itemValue: null)) {
    on<UpdateItemValue>(_onUpdateItemValue);
    on<ResetUnitValues>(_onResetUnitValues);
    on<ResetParamValues>(_onResetParamValues);
  }

  _onUpdateItemValue(
    UpdateItemValue event,
    Emitter<ConversionItemState> emit,
  ) async {
    emit(
      ConversionItemState(
        id: event.id,
        itemValue: event.newItemValue,
        isSource: event is UpdateUnitValue ? event.isSource : false,
        isParamValueInitialState:
            event is UpdateParamValue ? false : state.isParamValueInitialState,
        isUnitValueInitialState:
            event is UpdateUnitValue ? false : state.isUnitValueInitialState,
      ),
    );
  }

  _onResetUnitValues(
    ResetUnitValues event,
    Emitter<ConversionItemState> emit,
  ) async {
    emit(
      ConversionItemState(
        id: state.id,
        itemValue: state.itemValue,
        isSource: state.isSource,
        isParamValueInitialState: state.isParamValueInitialState,
        isUnitValueInitialState: true,
      ),
    );
  }

  _onResetParamValues(
    ResetParamValues event,
    Emitter<ConversionItemState> emit,
  ) async {
    emit(
      ConversionItemState(
        id: state.id,
        itemValue: state.itemValue,
        isSource: state.isSource,
        isParamValueInitialState: true,
        isUnitValueInitialState: state.isUnitValueInitialState,
      ),
    );
  }
}
