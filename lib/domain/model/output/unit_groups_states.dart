import 'package:convertouch/domain/model/output/abstract_state.dart';
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

  const UnitGroupsFetched({
    required this.unitGroups,
    this.searchString,
  });

  @override
  List<Object?> get props => [
    unitGroups,
    searchString,
  ];

  @override
  String toString() {
    return 'UnitGroupsFetched{'
        'unitGroups: $unitGroups}';
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

class UnitGroupsFetchedForUnitCreation extends UnitGroupsFetched {
  final UnitGroupModel? unitGroupInUnitCreation;

  const UnitGroupsFetchedForUnitCreation({
    required super.unitGroups,
    this.unitGroupInUnitCreation,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
    unitGroupInUnitCreation,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitGroupsFetchedForUnitCreation{'
        'unitGroupInUnitCreation: $unitGroupInUnitCreation}';
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

class UnitGroupsErrorState extends UnitGroupsState {
  final String message;

  const UnitGroupsErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [
    message,
  ];

  @override
  String toString() {
    return 'UnitGroupsErrorState{message: $message}';
  }
}
