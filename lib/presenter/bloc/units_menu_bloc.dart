import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsMenuBloc extends Bloc<UnitsMenuEvent, UnitsMenuState> {
  UnitsMenuBloc() : super(const UnitsFetched(units: []));

  @override
  Stream<UnitsMenuState> mapEventToState(UnitsMenuEvent event) async* {
    if (event is FetchUnits) {
      yield const UnitsFetching();
      yield const UnitsFetched(units: allUnits);
    } else if (event is SelectUnits) {
      yield UnitsSelected(selectedUnits: getSelectedUnits(event.unitIds));
    }
  }

  List<UnitModel> getSelectedUnits(List<int> selectedUnitIds) {
    if (selectedUnitIds.isNotEmpty) {
      return allUnits.where((unit) => selectedUnitIds.contains(unit.id))
          .toList();
    }
    return [];
  }
}

const List<UnitModel> allUnits = [
  UnitModel(1, 'Centimeter', 'cm'),
  UnitModel(2, 'Centimeter Square', 'cm2'),
  UnitModel(3, 'Centimeter Square', 'mm2'),
  UnitModel(1, 'Centimeter', 'cm'),
  UnitModel(2, 'Centimeter Square', 'mm3'),
  UnitModel(3, 'Centimeter Square', 'cm2'),
  UnitModel(1, 'Centimeter', 'cm'),
  UnitModel(2, 'Centimeter Square', 'mm4'),
  UnitModel(3, 'Centimeter Square', 'cm2'),
  UnitModel(1, 'Centimeter', 'cm'),
  UnitModel(2, 'Centimeter Square2 g uygtyfty tyf tyf ygf tyfyt t', 'km/h'),
  UnitModel(3, 'Centimeter Square hhhh hhhhhhhh', 'cm2'),
  UnitModel(1, 'Centimeter', 'cm'),
  UnitModel(2, 'Centimeter Square', 'cm2'),
  UnitModel(3, 'Centimeter Square', 'cm2'),
  UnitModel(1, 'Centimeter', 'cm'),
  UnitModel(2, 'Centimeter Square', 'cm2'),
  UnitModel(3, 'Centimeter Square', 'cm2'),
  UnitModel(1, 'Centimeter', 'cm'),
  UnitModel(2, 'Centimeter Square', 'cm2'),
  UnitModel(3, 'Centimeter Square', 'cm2'),
];