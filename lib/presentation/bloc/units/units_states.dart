import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
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
    this.markedUnits = const [],
    this.newMarkedUnit,
    this.addedUnitId = -1,
    this.inputValue = "1",
    this.selectedUnit,
    this.action = ConvertouchAction.fetchUnitsToStartMark,
    this.useMarkedUnitsInConversion = false,
  });

  final List<UnitModel> units;
  final UnitGroupModel unitGroup;
  final List<UnitModel> markedUnits;
  final UnitModel? newMarkedUnit;
  final int addedUnitId;
  final String inputValue;
  final UnitModel? selectedUnit;
  final ConvertouchAction action;
  final bool useMarkedUnitsInConversion;

  @override
  List<Object> get props => [
    units,
    unitGroup,
    inputValue,
    action,
    useMarkedUnitsInConversion,
    markedUnits,
  ];

  @override
  String toString() {
    return 'UnitsFetched{'
        'units: $units, '
        'unitGroup: $unitGroup, '
        'addedUnitId: $addedUnitId, '
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

class UnitsErrorState extends UnitsState {
  final String message;

  const UnitsErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'UnitsErrorState{message: $message}';
  }
}