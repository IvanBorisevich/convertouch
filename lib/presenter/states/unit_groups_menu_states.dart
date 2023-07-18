import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

abstract class UnitGroupsMenuState extends ConvertouchBlocState {
  const UnitGroupsMenuState({String? triggeredBy})
      : super(triggeredBy: triggeredBy);
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