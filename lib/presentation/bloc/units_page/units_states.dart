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
  final bool floatingButtonVisible;

  const UnitsFetched({
    this.units = const [],
    this.floatingButtonVisible = true,
  });

  @override
  List<Object?> get props => [
    units,
    floatingButtonVisible,
  ];

  @override
  String toString() {
    return 'UnitsFetched{'
        'units: $units, '
        'floatingButtonVisible: $floatingButtonVisible}';
  }
}


class UnitsFetchedForConversion extends UnitsFetched {
  final List<int> unitIdsAlreadyInConversion;
  final List<int> unitIdsSelectedForConversion;

  const UnitsFetchedForConversion({
    required super.units,
    required this.unitIdsAlreadyInConversion,
    required this.unitIdsSelectedForConversion,
    super.floatingButtonVisible = false,
  });

  @override
  List<Object?> get props => [
    unitIdsAlreadyInConversion,
    unitIdsSelectedForConversion,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitsFetchedForConversion{'
        'unitIdsAlreadyInConversion: $unitIdsAlreadyInConversion, '
        'unitIdsSelectedForConversion: $unitIdsSelectedForConversion, '
        '${super.toString()}}';
  }
}


class UnitsFetchedForEquivalentUnitSelection extends UnitsFetched {
  final UnitModel? selectedEquivalentUnit;

  const UnitsFetchedForEquivalentUnitSelection({
    required super.units,
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