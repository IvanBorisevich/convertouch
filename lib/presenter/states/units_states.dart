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
    this.conversionUnitIds,
    this.addedUnit,
    this.forPage,
  });

  final List<UnitModel> units;
  final UnitGroupModel unitGroup;
  final List<int>? conversionUnitIds;
  final UnitModel? addedUnit;
  final String? forPage;

  @override
  List<Object> get props => [units, unitGroup];

  @override
  String toString() {
    return 'UnitsFetched{'
        'units: $units, '
        'unitGroup: $unitGroup, '
        'addedUnit: $addedUnit, '
        'conversionUnitIds: $conversionUnitIds,'
        'forPage: $forPage}';
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

class UnitSelecting extends UnitsState {
  const UnitSelecting();

  @override
  String toString() {
    return 'UnitSelecting{}';
  }
}

class UnitSelected extends UnitsState {
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