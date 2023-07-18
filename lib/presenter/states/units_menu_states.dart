import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

abstract class UnitsMenuState extends ConvertouchBlocState {
  const UnitsMenuState({
    String? triggeredBy
  }) : super(triggeredBy: triggeredBy);
}

class UnitsMenuInitState extends UnitsMenuState {
  const UnitsMenuInitState();

  @override
  String toString() {
    return 'UnitsMenuInitState{}';
  }
}

class UnitsFetching extends UnitsMenuState {
  const UnitsFetching();

  @override
  String toString() {
    return 'UnitsFetching{}';
  }
}

class UnitsFetched extends UnitsMenuState {
  const UnitsFetched({
    required this.units,
    required this.unitGroup,
    this.addedUnit,
    String? triggeredBy,
  }) : super(triggeredBy: triggeredBy);

  final List<UnitModel> units;
  final UnitGroupModel unitGroup;
  final UnitModel? addedUnit;

  @override
  List<Object> get props => [units, unitGroup];

  @override
  String toString() {
    return 'UnitsFetched{'
        'units: $units, '
        'unitGroup: $unitGroup, '
        'addedUnit: $addedUnit, '
        'triggeredBy: $triggeredBy}';
  }
}


class UnitChecking extends UnitsMenuState {
  const UnitChecking();

  @override
  String toString() {
    return 'UnitChecking{}';
  }
}

class UnitExists extends UnitsMenuState {
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

class UnitSelecting extends UnitsMenuState {
  const UnitSelecting();

  @override
  String toString() {
    return 'UnitSelecting{}';
  }
}

class UnitSelected extends UnitsMenuState {
  const UnitSelected({
    required this.unitId
  });

  final int unitId;

  @override
  List<Object> get props => [unitId];

  @override
  String toString() {
    return 'UnitSelected{unitId: $unitId}';
  }
}