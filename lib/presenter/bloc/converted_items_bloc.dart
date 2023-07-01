import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/model/entity/unit_value_model.dart';
import 'package:convertouch/presenter/events/base_event.dart';
import 'package:convertouch/presenter/events/converted_items_fetch_event.dart';
import 'package:convertouch/presenter/states/converted_items_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConvertedItemsBloc extends Bloc<ConvertouchEvent, ConvertedItemsState> {
  ConvertedItemsBloc() : super(const ConvertedItemsState(convertedItems: []));

  List<UnitValueModel> _convertedItems = [];

  List<UnitValueModel> get convertedItems => _convertedItems;

  @override
  Stream<ConvertedItemsState> mapEventToState(ConvertouchEvent event) async* {
    if (event is ConvertedItemsFetchEvent) {
      _convertedItems = _convertItems(event.valueToConvert, event.units);
      yield ConvertedItemsState(
          convertedItems: _convertedItems);
    }
  }

  List<UnitValueModel> _convertItems(
      String valueToConvert, List<UnitModel> units) {
    List<UnitValueModel> convertedItems = [];
    for (var i = 0; i < units.length; i++) {
      convertedItems.add(UnitValueModel(units[i], '1'));
    }
    return convertedItems;
  }
}
