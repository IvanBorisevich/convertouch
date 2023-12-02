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
  final bool floatingButtonVisible;

  const UnitsFetched({
    this.units = const [],
    this.unitGroup,
    this.floatingButtonVisible = true,
  });

  @override
  List<Object?> get props => [
    units,
    unitGroup,
    floatingButtonVisible,
  ];

  @override
  String toString() {
    return 'UnitsFetched{'
        'units: $units, '
        'unitGroup: $unitGroup, '
        'floatingButtonVisible: $floatingButtonVisible}';
  }
}


class UnitsFetchedForConversion extends UnitsFetched {
  final List<UnitModel> unitsMarkedForConversion;
  final List<int> unitIdsMarkedForConversion;
  final bool allowUnitsToBeAddedToConversion;

  const UnitsFetchedForConversion({
    required super.units,
    required super.unitGroup,
    required this.unitsMarkedForConversion,
    required this.unitIdsMarkedForConversion,
    required this.allowUnitsToBeAddedToConversion,
    super.floatingButtonVisible = false,
  });

  @override
  List<Object?> get props => [
    unitsMarkedForConversion,
    unitIdsMarkedForConversion,
    allowUnitsToBeAddedToConversion,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitsFetchedForConversion{'
        'unitsMarkedForConversion: $unitsMarkedForConversion, '
        'allowUnitsToBeAddedToConversion: $allowUnitsToBeAddedToConversion}';
  }
}


class UnitsFetchedForEquivalentUnitSelection extends UnitsFetched {
  final UnitModel? selectedEquivalentUnit;

  const UnitsFetchedForEquivalentUnitSelection({
    required super.units,
    required super.unitGroup,
    this.selectedEquivalentUnit,
    super.floatingButtonVisible = false,
  });

  @override
  List<Object?> get props => [
    selectedEquivalentUnit,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitsFetchedForEquivalentUnitSelection{'
        'selectedEquivalentUnit: $selectedEquivalentUnit, '
        '${super.toString()}}';
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