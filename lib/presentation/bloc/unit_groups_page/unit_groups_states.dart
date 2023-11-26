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
  final bool floatingButtonVisible;

  const UnitGroupsFetched({
    required this.unitGroups,
    this.floatingButtonVisible = true,
  });

  @override
  List<Object?> get props => [
    unitGroups,
    floatingButtonVisible,
  ];

  @override
  String toString() {
    return 'UnitGroupsFetched{'
        'unitGroups: $unitGroups}';
  }
}

class UnitGroupsFetchedForConversion extends UnitGroupsFetched {
  final UnitGroupModel? unitGroupInConversion;

  const UnitGroupsFetchedForConversion({
    required super.unitGroups,
    this.unitGroupInConversion,
    super.floatingButtonVisible = false,
  });

  @override
  List<Object?> get props => [
    unitGroupInConversion,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitGroupsFetchedForConversion{'
        'unitGroupInConversion: $unitGroupInConversion}';
  }
}

class UnitGroupsFetchedForUnitCreation extends UnitGroupsFetched {
  final UnitGroupModel? unitGroupInUnitCreation;

  const UnitGroupsFetchedForUnitCreation({
    required super.unitGroups,
    this.unitGroupInUnitCreation,
    super.floatingButtonVisible = false,
  });

  @override
  List<Object?> get props => [
    unitGroupInUnitCreation,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitGroupsFetchedForUnitCreation{'
        'unitGroups: $unitGroups, '
        'unitGroupInUnitCreation: $unitGroupInUnitCreation}';
  }
}


class UnitGroupsErrorState extends UnitGroupsState {
  final String message;

  const UnitGroupsErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'UnitGroupsErrorState{message: $message}';
  }
}