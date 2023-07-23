import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

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

  final List<UnitModel> units;
  final UnitGroupModel unitGroup;
  final List<UnitModel>? markedUnits;
  final UnitModel? newMarkedUnit;
  final UnitModel? addedUnit;
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