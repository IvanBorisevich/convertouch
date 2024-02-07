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
  final int? addedId;

  const UnitGroupsFetched({
    required this.unitGroups,
    this.searchString,
    this.removalMode = false,
    this.markedIdsForRemoval = const [],
    this.removedIds = const [],
    this.addedId,
  });

  @override
  List<Object?> get props => [
    unitGroups,
    searchString,
    removalMode,
    markedIdsForRemoval,
    removedIds,
    addedId,
  ];

  @override
  String toString() {
    return 'UnitGroupsFetched{'
        'unitGroups: $unitGroups, '
        'removedIds: $removedIds, '
        'addedId: $addedId}';
  }
}

abstract class UnitGroupsFetchedForConversion extends UnitGroupsFetched {
  const UnitGroupsFetchedForConversion({
    required super.unitGroups,
    required super.searchString,
  });
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

class UnitGroupExists extends UnitGroupsState {
  final String unitGroupName;

  const UnitGroupExists({
    required this.unitGroupName,
  });

  @override
  List<Object?> get props => [
    unitGroupName,
  ];

  @override
  String toString() {
    return 'UnitGroupExists{'
        'unitGroupName: $unitGroupName}';
  }
}

class UnitGroupsErrorState extends ConvertouchErrorState
    implements UnitGroupsState {
  const UnitGroupsErrorState({
    required super.exception,
    required super.lastSuccessfulState,
  });

  @override
  String toString() {
    return 'UnitGroupsErrorState{'
        'exception: $exception}';
  }
}
