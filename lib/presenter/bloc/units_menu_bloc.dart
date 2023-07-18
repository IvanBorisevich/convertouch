import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/bloc/unit_groups_menu_bloc.dart';
import 'package:convertouch/presenter/events/units_menu_events.dart';
import 'package:convertouch/presenter/states/units_menu_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnitsMenuBloc extends Bloc<UnitsMenuEvent, UnitsMenuState> {
  UnitsMenuBloc() : super(const UnitsMenuInitState());

  @override
  Stream<UnitsMenuState> mapEventToState(UnitsMenuEvent event) async* {
    if (event is FetchUnits) {
      yield const UnitsFetching();
      UnitGroupModel unitGroup = getUnitGroup(event.unitGroupId);
      yield UnitsFetched(
          units: allUnits,
          unitGroup: unitGroup,
          triggeredBy: event.triggeredBy);
    } else if (event is AddUnit) {
      yield const UnitChecking();
      bool unitExists = allUnits.any((unit) => unit.name == event.unitName);
      if (unitExists) {
        yield UnitExists(unitName: event.unitName);
      } else {
        yield const UnitsFetching();
        UnitModel newUnit = UnitModel(
            id: allUnits.length + 1,
            name: event.unitName,
            abbreviation: event.unitAbbreviation);
        allUnits.add(newUnit);
        yield UnitsFetched(
            units: allUnits,
            addedUnit: newUnit,
            unitGroup: event.unitGroup,
            triggeredBy: event.triggeredBy);
      }
    } else if (event is SelectUnit) {
      yield const UnitSelecting();
      yield UnitSelected(unitId: event.unitId);
    }
  }
}

List<UnitModel> getUnits(List<int> selectedUnitIds) {
  if (selectedUnitIds.isNotEmpty) {
    return allUnits.where((unit) => selectedUnitIds.contains(unit.id)).toList();
  }
  return [];
}

UnitModel? getUnit(int? unitId) {
  return unitId != null
      ? allUnits.firstWhere((unit) => unit.id == unitId)
      : null;
}

UnitGroupModel getUnitGroup(int unitGroupId) {
  return allUnitGroups.firstWhere((unitGroup) => unitGroup.id == unitGroupId);
}

final List<UnitModel> allUnits = [
  UnitModel(id: 1, name: 'Centimeter', abbreviation: 'cm'),
  UnitModel(id: 2, name: 'Centimeter Square', abbreviation: 'cm2'),
  UnitModel(id: 3, name: 'Centimeter Square', abbreviation: 'mm2'),
  UnitModel(id: 4, name: 'Meter', abbreviation: 'm'),
  UnitModel(id: 5, name: 'Centimeter Square', abbreviation: 'mm3'),
  UnitModel(id: 6, name: 'Centimeter Square', abbreviation: 'cm2'),
  UnitModel(id: 7, name: 'Centimeter', abbreviation: 'cm'),
  // UnitModel(8, 'Centimeter Square', 'mm4'),
  // UnitModel(9, 'Centimeter Square', 'cm2'),
  // UnitModel(10, 'Centimeter', 'cm'),
  // UnitModel(11, 'Centimeter Square2 g uygtyfty tyf tyf ygf tyfyt t', 'km/h'),
  // UnitModel(12, 'Centimeter Square hhhh hhhhhhhh', 'cm2'),
  // UnitModel(13, 'Centimeter', 'cm'),
  // UnitModel(14, 'Centimeter Square', 'cm2'),
  // UnitModel(15, 'Centimeter Square', 'cm2'),
  // UnitModel(16, 'Centimeter', 'cm'),
  // UnitModel(17, 'Centimeter Square', 'cm2'),
  // UnitModel(18, 'Centimeter Square', 'cm2'),
  // UnitModel(19, 'Centimeter', 'cm'),
  // UnitModel(20, 'Centimeter Square', 'cm2'),
  // UnitModel(21, 'Centimeter Square', 'cm2'),
];
