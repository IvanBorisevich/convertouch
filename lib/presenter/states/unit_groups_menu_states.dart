import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/states/base_state.dart';

abstract class UnitGroupsMenuState extends ConvertouchBlocState {
  const UnitGroupsMenuState();
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
    required this.unitGroups
  });

  final List<UnitGroupModel> unitGroups;

  @override
  List<Object> get props => [unitGroups];

  @override
  String toString() {
    return 'UnitGroupsFetched{unitsGroups: $unitGroups}';
  }
}

class UnitGroupAdding extends UnitGroupsMenuState {
  const UnitGroupAdding();

  @override
  String toString() {
    return 'UnitGroupAdding{}';
  }
}

class UnitGroupAdded extends UnitGroupsMenuState {
  const UnitGroupAdded({
    required this.unitGroup
  });

  final UnitGroupModel unitGroup;

  @override
  List<Object> get props => [unitGroup];

  @override
  String toString() {
    return 'UnitGroupAdded{unitGroup: $unitGroup}';
  }
}

class UnitGroupExists extends UnitGroupsMenuState {
  const UnitGroupExists({
    required this.unitGroupName
  });

  final String unitGroupName;

  @override
  List<Object> get props => [unitGroupName];

  @override
  String toString() {
    return 'UnitGroupExists{unitGroupName: $unitGroupName}';
  }
}