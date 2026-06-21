import 'package:convertouch/presentation/bloc/abstract_bloc.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_events.dart';
import 'package:convertouch/presentation/bloc/conversion_page/conversion_item/conversion_item_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversionItemBloc
    extends ConvertouchBloc<ConversionItemEvent, ConversionItemState> {
  ConversionItemBloc() : super(const ConversionItemInitialState()) {
    on<UpdateItemValue>(_updateItemValue);
    on<ResetItemValues>(_resetItemValues);
  }

  _updateItemValue(
    UpdateItemValue event,
    Emitter<ConversionItemState> emit,
  ) async {
    emit(
      ConversionItemUpdated(
        id: event.id,
        value: event.newValue,
        isSource: event.isSource,
      ),
    );
  }

  _resetItemValues(
    ResetItemValues event,
    Emitter<ConversionItemState> emit,
  ) async {
    emit(const ConversionItemInitialState());
  }
}
