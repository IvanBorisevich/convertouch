import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:equatable/equatable.dart';

abstract class UnitsState extends Equatable {
  const UnitsState();

  @override
  List<Object?> get props => [];
}

class UnitsFetching extends UnitsState {
  const UnitsFetching();

  @override
  String toString() {
    return 'UnitsFetching{}';
  }
}

class UnitsFetched extends UnitsState {
  final List<UnitModel> units;
  final UnitGroupModel? unitGroup;

  const UnitsFetched({
    this.units = const [],
    this.unitGroup,
  });

  @override
  List<Object?> get props => [
    units,
    unitGroup,
  ];

  @override
  String toString() {
    return 'UnitsFetched{'
        'units: $units, '
        'unitGroup: $unitGroup}';
  }
}


class UnitsFetchedForConversion extends UnitsState {
  final List<UnitModel> unitsMarkedForConversion;
  final List<int> unitIdsMarkedForConversion;
  final bool allowUnitsToBeAddedToConversion;

  const UnitsFetchedForConversion({
    required this.unitsMarkedForConversion,
    required this.unitIdsMarkedForConversion,
    required this.allowUnitsToBeAddedToConversion,
  });

  @override
  List<Object?> get props => [
    unitsMarkedForConversion,
    unitIdsMarkedForConversion,
    allowUnitsToBeAddedToConversion,
  ];

  @override
  String toString() {
    return 'UnitsFetchedForConversion{'
        'unitsMarkedForConversion: $unitsMarkedForConversion, '
        'allowUnitsToBeAddedToConversion: $allowUnitsToBeAddedToConversion}';
  }
}


class UnitsFetchedForEquivalentUnitSelection extends UnitsState {
  final UnitModel? selectedEquivalentUnit;

  const UnitsFetchedForEquivalentUnitSelection({
    this.selectedEquivalentUnit,
  });

  @override
  List<Object?> get props => [
    selectedEquivalentUnit,
  ];

  @override
  String toString() {
    return 'UnitsFetchedForEquivalentUnitSelection{'
        'selectedEquivalentUnit: $selectedEquivalentUnit}';
  }
}

class UnitsErrorState extends UnitsState {
  final String message;

  const UnitsErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'UnitsErrorState{message: $message}';
  }
}