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
      unitGroup.ciUnit = getUnit(unitGroup.ciUnitId);
      yield UnitsFetched(
          units: allUnits,
          unitGroup: unitGroup,
          navigationAction: event.navigationAction
      );
    } else if (event is AddUnit) {
      yield const UnitChecking();
      bool unitExists = allUnits.any((unit) => unit.name == event.unitName);
      if (unitExists) {
        yield UnitExists(unitName: event.unitName);
      } else {
        yield const UnitAdding();
        UnitModel newUnit = UnitModel(
            allUnits.length + 1, event.unitName, event.unitAbbreviation);
        allUnits.add(newUnit);
        yield UnitAdded(addedUnit: newUnit);
      }
    }
  }
}

List<UnitModel> getUnits(List<int> selectedUnitIds) {
  if (selectedUnitIds.isNotEmpty) {
    return allUnits
        .where((unit) => selectedUnitIds.contains(unit.id))
        .toList();
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
  UnitModel(1, 'Centimeter', 'cm'),
  UnitModel(2, 'Centimeter Square', 'cm2'),
  UnitModel(3, 'Centimeter Square', 'mm2'),
  UnitModel(4, 'Meter', 'm'),
  UnitModel(5, 'Centimeter Square', 'mm3'),
  UnitModel(6, 'Centimeter Square', 'cm2'),
  UnitModel(7, 'Centimeter', 'cm'),
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