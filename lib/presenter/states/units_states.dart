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
    this.markedUnitIds,
    this.newMarkedUnitId,
    this.addedUnit,
    this.selectedUnit,
    this.itemClickAction = ItemClickAction.mark,
    this.canMarkedUnitsBeSelected = false,
    this.forPage,
  });

  final List<UnitModel> units;
  final UnitGroupModel unitGroup;
  final List<int>? markedUnitIds;
  final int? newMarkedUnitId;
  final UnitModel? addedUnit;
  final UnitModel? selectedUnit;
  final ItemClickAction itemClickAction;
  final bool canMarkedUnitsBeSelected;
  final String? forPage;

  @override
  List<Object> get props => [
    units,
    unitGroup,
    itemClickAction,
    canMarkedUnitsBeSelected,
  ];

  @override
  String toString() {
    return 'UnitsFetched{'
        'units: $units, '
        'unitGroup: $unitGroup, '
        'addedUnit: $addedUnit, '
        'selectedUnit: $selectedUnit, '
        'markedUnitIds: $markedUnitIds, '
        'newMarkedUnitId: $newMarkedUnitId, '
        'itemClickAction: $itemClickAction, '
        'canMarkedUnitsBeSelected: $canMarkedUnitsBeSelected, '
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