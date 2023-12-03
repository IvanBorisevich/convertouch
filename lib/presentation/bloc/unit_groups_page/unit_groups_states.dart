import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:equatable/equatable.dart';

abstract class UnitGroupsState extends Equatable {
  const UnitGroupsState();

  @override
  List<Object?> get props => [];
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

  const UnitGroupsFetched({
    required this.unitGroups,
  });

  @override
  List<Object?> get props => [
    unitGroups,
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
  });
}

class UnitGroupsFetchedForFirstAddingToConversion extends UnitGroupsFetchedForConversion {
  const UnitGroupsFetchedForFirstAddingToConversion({
    required super.unitGroups,
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
