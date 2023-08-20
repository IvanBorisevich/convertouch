import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/entities/unit_group_entity.dart';
import 'package:convertouch/domain/entities/unit_entity.dart';
import 'package:convertouch/presentation/bloc/base_state.dart';

abstract class UnitsState extends ConvertouchBlocState {
  const UnitsState();
}

class UnitsInitState extends UnitsState {
  const UnitsInitState();

  @override
  String toString() {
    return 'UnitsMenuInitState{}';
  }
}

class UnitsFetching extends UnitsState {
  const UnitsFetching();

  @override
  String toString() {
    return 'UnitsFetching{}';
  }
}

class UnitsFetched extends UnitsState {
  const UnitsFetched({
    required this.units,
    required this.unitGroup,
    this.markedUnits,
    this.newMarkedUnit,
    this.addedUnit,
    this.inputValue = "1",
    this.selectedUnit,
    this.action = ConvertouchAction.fetchUnitsToStartMark,
    this.useMarkedUnitsInConversion = false,
  });

  final List<UnitEntity> units;
  final UnitGroupEntity unitGroup;
  final List<UnitEntity>? markedUnits;
  final UnitEntity? newMarkedUnit;
  final UnitEntity? addedUnit;
  final String inputValue;
  final UnitEntity? selectedUnit;
  final ConvertouchAction action;
  final bool useMarkedUnitsInConversion;

  @override
  List<Object> get props => [
    units,
    unitGroup,
    inputValue,
    action,
    useMarkedUnitsInConversion,
  ];

  @override
  String toString() {
    return 'UnitsFetched{'
        //'units: $units, '
        'unitGroup: $unitGroup, '
        'addedUnit: $addedUnit, '
        'inputValue: $inputValue, '
        'selectedUnit: $selectedUnit, '
        'markedUnits: $markedUnits, '
        'newMarkedUnit: $newMarkedUnit, '
        'action: $action, '
        'useMarkedUnitsInConversion: $useMarkedUnitsInConversion}';
  }
}


class UnitChecking extends UnitsState {
  const UnitChecking();

  @override
  String toString() {
    return 'UnitChecking{}';
  }
}

class UnitExists extends UnitsState {
  const UnitExists({
    required this.unitName
  });

  final String unitName;

  @override
  List<Object> get props => [unitName];

  @override
  String toString() {
    return 'UnitExists{unitName: $unitName}';
  }
}