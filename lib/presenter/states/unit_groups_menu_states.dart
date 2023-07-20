import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

abstract class UnitGroupsMenuState extends ConvertouchBlocState {
  const UnitGroupsMenuState({String? triggeredBy})
      : super(triggeredBy: triggeredBy);
}

class UnitGroupsInitState extends UnitGroupsMenuState {
  const UnitGroupsInitState();

  @override
  String toString() {
    return 'UnitGroupsInitState{}';
  }
}

class UnitGroupsFetching extends UnitGroupsMenuState {
  const UnitGroupsFetching();

  @override
  String toString() {
    return 'UnitGroupsFetching{}';
  }
}

class UnitGroupsFetched extends UnitGroupsMenuState {
  const UnitGroupsFetched({
    required this.unitGroups,
    this.addedUnitGroup,
    String? triggeredBy,
  }) : super(triggeredBy: triggeredBy);

  final List<UnitGroupModel> unitGroups;
  final UnitGroupModel? addedUnitGroup;

  @override
  List<Object> get props => [unitGroups];

  @override
  String toString() {
    return 'UnitGroupsFetched{'
        'unitsGroups: $unitGroups, '
        'addedUnitGroup: $addedUnitGroup, '
        'triggeredBy: $triggeredBy}';
  }
}

class UnitGroupExists extends UnitGroupsMenuState {
  const UnitGroupExists({required this.unitGroupName});

  final String unitGroupName;

  @override
  List<Object> get props => [unitGroupName];

  @override
  String toString() {
    return 'UnitGroupExists{unitGroupName: $unitGroupName}';
  }
}

class UnitGroupSelecting extends UnitGroupsMenuState {
  const UnitGroupSelecting();

  @override
  String toString() {
    return 'UnitGroupSelecting{}';
  }
}

class UnitGroupSelected extends UnitGroupsMenuState {
  const UnitGroupSelected({
    required this.unitGroup,
    String? triggeredBy,
  }) : super(triggeredBy: triggeredBy);

  final UnitGroupModel unitGroup;

  @override
  List<Object> get props => [unitGroup];

  @override
  String toString() {
    return 'UnitGroupSelected{'
        'unitGroup: $unitGroup, '
        'triggeredBy: $triggeredBy}';
  }
}