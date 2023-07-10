import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

abstract class UnitsMenuState extends ConvertouchBlocState {
  const UnitsMenuState();
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
    this.navigationAction,
  });

  final List<UnitModel> units;
  final UnitGroupModel unitGroup;
  final NavigationAction? navigationAction;

  @override
  List<Object> get props => [units, unitGroup];

  @override
  String toString() {
    return 'UnitsFetched{'
        'units: $units, '
        'unitGroup: $unitGroup}';
  }
}


class UnitChecking extends UnitsMenuState {
  const UnitChecking();

  @override
  String toString() {
    return 'UnitChecking{}';
  }
}

class UnitAdding extends UnitsMenuState {
  const UnitAdding();

  @override
  String toString() {
    return 'UnitAdding{}';
  }
}

class UnitAdded extends UnitsMenuState {
  const UnitAdded({
    required this.addedUnit,
  });

  final UnitModel addedUnit;

  @override
  List<Object> get props => [addedUnit];

  @override
  String toString() {
    return 'UnitAdded{addedUnit: $addedUnit}';
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