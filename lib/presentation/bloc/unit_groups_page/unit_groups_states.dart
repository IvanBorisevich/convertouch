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

class UnitGroupsFetchedToFetchUnitsForConversion extends UnitGroupsState {
  const UnitGroupsFetchedToFetchUnitsForConversion();

  @override
  String toString() {
    return 'UnitGroupsFetchedToFetchUnitsForConversion{}';
  }
}

class UnitGroupsFetchedToChangeOneInConversion extends UnitGroupsState {
  final UnitGroupModel unitGroupInConversion;

  const UnitGroupsFetchedToChangeOneInConversion({
    required this.unitGroupInConversion,
  });

  @override
  String toString() {
    return 'UnitGroupsFetchedToChangeOneInConversion{'
        'unitGroupInConversion: $unitGroupInConversion}';
  }
}

class UnitGroupsFetchedForUnitCreation extends UnitGroupsState {
  final UnitGroupModel? unitGroupInUnitCreation;

  const UnitGroupsFetchedForUnitCreation({
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
  List<Object> get props => [message];

  @override
  String toString() {
    return 'UnitGroupsErrorState{message: $message}';
  }
}