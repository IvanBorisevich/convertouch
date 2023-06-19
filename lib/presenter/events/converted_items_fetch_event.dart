import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/events/base_event.dart';

class ConvertedItemsFetchEvent extends BlocEvent {
  const ConvertedItemsFetchEvent(this.valueToConvert, this.units);

  final String valueToConvert;
  final List<UnitModel> units;


  @override
  List<Object> get props => [
    valueToConvert,
    units
  ];

  @override
  String toString() {
    return 'ConvertedItemsFetchEvent{'
        'valueToConvert: $valueToConvert, '
        'units: $units}';
  }
}