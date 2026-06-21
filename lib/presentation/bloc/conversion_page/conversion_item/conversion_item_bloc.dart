import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ConversionItemBloc<
    T extends ItemValueModel,
    E extends ConversionItemEvent<T>,
    S extends ConversionItemState<T>> extends ConvertouchBloc<E, S> {
  ConversionItemBloc(super.initialState);
}

class ConversionUnitValueBloc extends ConversionItemBloc<
    ConversionUnitValueModel,
    ConversionUnitValueEvent,
    ConversionUnitValueState> {
  ConversionUnitValueBloc() : super(const ConversionUnitValueInitialState()) {
    on<UpdateUnitValue>(_onUpdateUnitValue);
    on<ResetUnitValues>(_onResetUnitValues);
  }

  _onUpdateUnitValue(
    UpdateUnitValue event,
    Emitter<ConversionUnitValueState> emit,
  ) async {
    emit(
      ConversionUnitValueUpdated(
        id: event.id,
        value: event.newValue,
        isSource: event.isSource,
      ),
    );
  }

  _onResetUnitValues(
    ResetUnitValues event,
    Emitter<ConversionUnitValueState> emit,
  ) async {
    emit(const ConversionUnitValueInitialState());
  }
}

class ConversionParamValueBloc extends ConversionItemBloc<
    ConversionParamValueModel,
    ConversionParamValueEvent,
    ConversionParamValueState> {
  ConversionParamValueBloc() : super(const ConversionParamValueInitialState()) {
    on<UpdateParamValue>(_onUpdateParamValue);
    on<ResetParamValues>(_onResetParamValues);
  }

  _onUpdateParamValue(
    UpdateParamValue event,
    Emitter<ConversionParamValueState> emit,
  ) async {
    emit(
      ConversionParamValueUpdated(
        id: event.id,
        value: event.newValue,
      ),
    );
  }

  _onResetParamValues(
    ResetParamValues event,
    Emitter<ConversionParamValueState> emit,
  ) async {
    emit(const ConversionParamValueInitialState());
  }
}
