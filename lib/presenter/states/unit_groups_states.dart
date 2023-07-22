import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
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
    this.markedUnitGroupIds,
    this.addedUnitGroup,
    this.initial = false,
    this.itemClickAction = ItemClickAction.fetch,
    this.forPage,
  });

  final List<UnitGroupModel> unitGroups;
  final List<int>? markedUnitGroupIds;
  final UnitGroupModel? addedUnitGroup;
  final bool initial;
  final ItemClickAction itemClickAction;
  final String? forPage;

  @override
  List<Object> get props => [
    unitGroups,
    initial,
    itemClickAction
  ];

  @override
  String toString() {
    return 'UnitGroupsFetched{'
        'unitsGroups: $unitGroups, '
        'markedUnitGroupIds: $markedUnitGroupIds, '
        'addedUnitGroup: $addedUnitGroup, '
        'initial: $initial, '
        'itemClickAction: $itemClickAction, '
        'forPage: $forPage}';
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