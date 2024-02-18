import 'package:convertouch/presentation/bloc/abstract_event.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

abstract class UnitGroupsEvent extends ConvertouchEvent {
  const UnitGroupsEvent();
}

class FetchUnitGroups extends UnitGroupsEvent {
  final String? searchString;
  final List<int> removedIds;
  final UnitGroupModel? modifiedUnitGroup;
  final bool rebuildConversion;

  const FetchUnitGroups({
    required this.searchString,
    this.removedIds = const [],
    this.modifiedUnitGroup,
    this.rebuildConversion = false,
  });

  @override
  List<Object?> get props => [
    searchString,
    removedIds,
    modifiedUnitGroup,
    rebuildConversion,
  ];

  @override
  String toString() {
    return 'FetchUnitGroups{'
        'searchString: $searchString, '
        'rebuildConversion: $rebuildConversion}';
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

class FetchUnitGroupsForUnitDetails extends FetchUnitGroups {
  final UnitGroupModel currentUnitGroupInUnitDetails;

  const FetchUnitGroupsForUnitDetails({
    required this.currentUnitGroupInUnitDetails,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
    currentUnitGroupInUnitDetails,
    super.props,
  ];

  @override
  String toString() {
    return 'FetchUnitGroupsForUnitDetails{'
        'currentUnitGroupInUnitDetails: $currentUnitGroupInUnitDetails,'
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
  List<Object?> get props => [
    ids,
    super.props,
  ];

  @override
  String toString() {
    return 'RemoveUnitGroups{'
        'ids: $ids}';
  }
}

class SaveUnitGroup extends UnitGroupsEvent {
  final UnitGroupModel unitGroupToBeSaved;
  final int? conversionGroupId;

  const SaveUnitGroup({
    required this.unitGroupToBeSaved,
    this.conversionGroupId,
  });

  @override
  List<Object?> get props => [
    unitGroupToBeSaved,
    conversionGroupId,
  ];

  @override
  String toString() {
    return 'SaveUnitGroup{'
        'unitGroupToBeSaved: $unitGroupToBeSaved, '
        'conversionGroupId: $conversionGroupId}';
  }
}

class DisableUnitGroupsRemovalMode extends UnitGroupsEvent {
  const DisableUnitGroupsRemovalMode();

  @override
  String toString() {
    return 'DisableUnitGroupsRemovalMode{}';
  }
}
