import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

abstract class UnitGroupsEvent extends ConvertouchEvent {
  const UnitGroupsEvent();
}

class FetchUnitGroups extends UnitGroupsEvent {
  final String? searchString;
  final List<int> removedIds;
  final int? addedId;

  const FetchUnitGroups({
    required this.searchString,
    this.removedIds = const [],
    this.addedId,
  });

  @override
  List<Object?> get props => [
    searchString,
    removedIds,
    addedId,
  ];

  @override
  String toString() {
    return 'FetchUnitGroups{searchString: $searchString}';
  }
}

class FetchUnitGroupsForFirstAddingToConversion extends FetchUnitGroups {
  const FetchUnitGroupsForFirstAddingToConversion({
    required super.searchString,
  });

  @override
  String toString() {
    return 'FetchUnitGroupsForFirstAddingToConversion{'
        '${super.toString()}}';
  }
}

class FetchUnitGroupsForChangeInConversion extends FetchUnitGroups {
  final UnitGroupModel currentUnitGroupInConversion;

  const FetchUnitGroupsForChangeInConversion({
    required this.currentUnitGroupInConversion,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
    currentUnitGroupInConversion,
    super.props,
  ];

  @override
  String toString() {
    return 'FetchUnitGroupsForChangeInConversion{'
        'currentUnitGroupInConversion: $currentUnitGroupInConversion,'
        '${super.toString()}}';
  }
}

class FetchUnitGroupsForUnitCreation extends FetchUnitGroups {
  final UnitGroupModel currentUnitGroupInUnitCreation;

  const FetchUnitGroupsForUnitCreation({
    required this.currentUnitGroupInUnitCreation,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
    currentUnitGroupInUnitCreation,
    super.props,
  ];

  @override
  String toString() {
    return 'FetchUnitGroupsForUnitCreation{'
        'currentUnitGroupInUnitCreation: $currentUnitGroupInUnitCreation,'
        '${super.toString()}}';
  }
}

class FetchUnitGroupsToMarkForRemoval extends FetchUnitGroups {
  final List<int> alreadyMarkedIds;
  final int newMarkedId;

  const FetchUnitGroupsToMarkForRemoval({
    this.alreadyMarkedIds = const [],
    required this.newMarkedId,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
    alreadyMarkedIds,
    newMarkedId,
    super.props,
  ];

  @override
  String toString() {
    return 'FetchUnitGroupsToMarkForRemoval{'
        'alreadyMarkedIds: $alreadyMarkedIds,'
        'newMarkedId: $newMarkedId}';
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

class DisableUnitGroupsRemovalMode extends UnitGroupsEvent {
  const DisableUnitGroupsRemovalMode();

  @override
  String toString() {
    return 'DisableUnitGroupsRemovalMode{}';
  }
}