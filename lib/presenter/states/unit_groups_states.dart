import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

abstract class UnitGroupsState extends ConvertouchBlocState {
  const UnitGroupsState();
}

class UnitGroupsInitState extends UnitGroupsState {
  const UnitGroupsInitState();

  @override
  String toString() {
    return 'UnitGroupsInitState{}';
  }
}

class UnitGroupsFetching extends UnitGroupsState {
  const UnitGroupsFetching();

  @override
  String toString() {
    return 'UnitGroupsFetching{}';
  }
}

class UnitGroupsFetched extends UnitGroupsState {
  const UnitGroupsFetched({
    required this.unitGroups,
    this.selectedUnitGroupId,
    this.addedUnitGroup,
    this.markedUnits,
    this.action = ConvertouchAction.fetchUnitGroupsToSelectForUnitsFetching,
  });

  final List<UnitGroupModel> unitGroups;
  final int? selectedUnitGroupId;
  final UnitGroupModel? addedUnitGroup;
  final List<UnitModel>? markedUnits;
  final ConvertouchAction action;

  @override
  List<Object> get props => [
    unitGroups,
    action
  ];

  @override
  String toString() {
    return 'UnitGroupsFetched{'
        'unitsGroups: $unitGroups, '
        'selectedUnitGroupId: $selectedUnitGroupId, '
        'addedUnitGroup: $addedUnitGroup, '
        'markedUnits: $markedUnits, '
        'action: $action}';
  }
}

class UnitGroupExists extends UnitGroupsState {
  const UnitGroupExists({required this.unitGroupName});

  final String unitGroupName;

  @override
  List<Object> get props => [unitGroupName];

  @override
  String toString() {
    return 'UnitGroupExists{unitGroupName: $unitGroupName}';
  }
}

class UnitGroupSelecting extends UnitGroupsState {
  const UnitGroupSelecting();

  @override
  String toString() {
    return 'UnitGroupSelecting{}';
  }
}

class UnitGroupSelected extends UnitGroupsState {
  const UnitGroupSelected({
    required this.unitGroup
  });

  final UnitGroupModel unitGroup;

  @override
  List<Object> get props => [unitGroup];

  @override
  String toString() {
    return 'UnitGroupSelected{unitGroup: $unitGroup}';
  }
}