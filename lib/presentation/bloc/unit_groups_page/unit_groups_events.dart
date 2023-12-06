import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:equatable/equatable.dart';

abstract class UnitGroupsEvent extends Equatable {
  const UnitGroupsEvent();

  @override
  List<Object?> get props => [];
}

class FetchUnitGroups extends UnitGroupsEvent {
  const FetchUnitGroups();

  @override
  String toString() {
    return 'FetchUnitGroups{}';
  }
}

class FetchUnitGroupsForFirstAddingToConversion extends FetchUnitGroups {
  const FetchUnitGroupsForFirstAddingToConversion();

  @override
  String toString() {
    return 'FetchUnitGroupsForFirstAddingToConversion{}';
  }
}

class FetchUnitGroupsForChangeInConversion extends FetchUnitGroups {
  final UnitGroupModel currentUnitGroupInConversion;

  const FetchUnitGroupsForChangeInConversion({
    required this.currentUnitGroupInConversion,
  });

  @override
  List<Object?> get props => [
    currentUnitGroupInConversion,
  ];

  @override
  String toString() {
    return 'FetchUnitGroupsForChangeInConversion{'
        'currentUnitGroupInConversion: $currentUnitGroupInConversion}';
  }
}

class FetchUnitGroupsForUnitCreation extends FetchUnitGroups {
  final UnitGroupModel currentUnitGroupInUnitCreation;

  const FetchUnitGroupsForUnitCreation({
    required this.currentUnitGroupInUnitCreation,
  });

  @override
  List<Object?> get props => [
    currentUnitGroupInUnitCreation,
  ];

  @override
  String toString() {
    return 'FetchUnitGroupsForUnitCreation{'
        'currentUnitGroupInUnitCreation: $currentUnitGroupInUnitCreation}';
  }
}


class RemoveUnitGroups extends UnitGroupsEvent {
  final List<int> ids;

  const RemoveUnitGroups({
    required this.ids,
  });

  @override
  List<Object> get props => [
    ids,
    super.props,
  ];

  @override
  String toString() {
    return 'RemoveUnitGroups{'
        'ids: $ids}';
  }
}

class AddUnitGroup extends UnitGroupsEvent {
  final String unitGroupName;

  const AddUnitGroup({
    required this.unitGroupName,
  });

  @override
  List<Object> get props => [
    unitGroupName,
  ];

  @override
  String toString() {
    return 'AddUnitGroup{'
        'unitGroupName: $unitGroupName}';
  }
}
