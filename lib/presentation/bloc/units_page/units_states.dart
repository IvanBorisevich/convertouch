import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
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
    required this.unitGroup,
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


class UnitsFetchedToMarkForConversion extends UnitsFetched {
  final List<UnitModel> unitsMarkedForConversion;
  final List<int> unitIdsMarkedForConversion;
  final bool allowUnitsToBeAddedToConversion;
  final UnitValueModel? currentSourceConversionItem;

  const UnitsFetchedToMarkForConversion({
    required super.units,
    required super.unitGroup,
    required this.unitsMarkedForConversion,
    required this.unitIdsMarkedForConversion,
    required this.allowUnitsToBeAddedToConversion,
    this.currentSourceConversionItem,
  });

  @override
  List<Object?> get props => [
    unitsMarkedForConversion,
    unitIdsMarkedForConversion,
    allowUnitsToBeAddedToConversion,
    currentSourceConversionItem,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitsFetchedToMarkForConversion{'
        'unitsMarkedForConversion: $unitsMarkedForConversion, '
        'unitIdsMarkedForConversion: $unitIdsMarkedForConversion, '
        'allowUnitsToBeAddedToConversion: $allowUnitsToBeAddedToConversion, '
        'currentSourceConversionItem: $currentSourceConversionItem}';
  }
}


class UnitsOpenedToSelectEquivalentUnit extends UnitsState {
  final UnitModel? currentSelectedEquivalentUnit;

  const UnitsOpenedToSelectEquivalentUnit({
    this.currentSelectedEquivalentUnit,
  });

  @override
  List<Object?> get props => [
    currentSelectedEquivalentUnit,
  ];

  @override
  String toString() {
    return 'UnitsOpenedToSelectEquivalentUnit{'
        'currentSelectedEquivalentUnit: $currentSelectedEquivalentUnit}';
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