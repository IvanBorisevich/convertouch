import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

abstract class UnitGroupsState extends ConvertouchState {
  const UnitGroupsState();
}

class UnitGroupsFetching extends UnitGroupsState {
  const UnitGroupsFetching();

  @override
  String toString() {
    return 'UnitGroupsFetching{}';
  }
}

class UnitGroupsFetched extends UnitGroupsState {
  final List<UnitGroupModel> unitGroups;
  final String? searchString;
  final bool removalMode;
  final List<int> markedIdsForRemoval;
  final List<int> removedIds;
  final UnitGroupModel? modifiedUnitGroup;
  final bool rebuildConversion;

  const UnitGroupsFetched({
    required this.unitGroups,
    this.searchString,
    this.removalMode = false,
    this.markedIdsForRemoval = const [],
    this.removedIds = const [],
    this.modifiedUnitGroup,
    this.rebuildConversion = false,
  });

  @override
  List<Object?> get props => [
    unitGroups,
    searchString,
    removalMode,
    markedIdsForRemoval,
    removedIds,
    modifiedUnitGroup,
    rebuildConversion,
  ];

  @override
  String toString() {
    return 'UnitGroupsFetched{'
        'unitGroups: $unitGroups, '
        'removedIds: $removedIds, '
        'modifiedUnitGroup: $modifiedUnitGroup, '
        'rebuildConversion: $rebuildConversion}';
  }
}

abstract class UnitGroupsFetchedForConversion extends UnitGroupsFetched {
  const UnitGroupsFetchedForConversion({
    required super.unitGroups,
    required super.searchString,
  });

  @override
  String toString() {
    return 'UnitGroupsFetchedForConversion{}';
  }
}

class UnitGroupsFetchedForFirstAddingToConversion extends UnitGroupsFetchedForConversion {
  const UnitGroupsFetchedForFirstAddingToConversion({
    required super.unitGroups,
    required super.searchString,
  });

  @override
  String toString() {
    return 'UnitGroupsFetchedForFirstAddingToConversion{'
        'unitGroups: $unitGroups}';
  }
}

class UnitGroupsFetchedForChangeInConversion extends UnitGroupsFetchedForConversion {
  final UnitGroupModel currentUnitGroupInConversion;

  const UnitGroupsFetchedForChangeInConversion({
    required super.unitGroups,
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
    return 'UnitGroupsFetchedForChangeInConversion{'
        'currentUnitGroupInConversion: $currentUnitGroupInConversion}';
  }
}

class UnitGroupsFetchedForUnitDetails extends UnitGroupsFetched {
  final UnitGroupModel? unitGroupInUnitDetails;

  const UnitGroupsFetchedForUnitDetails({
    required super.unitGroups,
    this.unitGroupInUnitDetails,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
    unitGroupInUnitDetails,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitGroupsFetchedForUnitDetails{'
        'unitGroupInUnitDetails: $unitGroupInUnitDetails}';
  }
}