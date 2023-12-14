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
  final String? searchString;

  const UnitsFetched({
    this.units = const [],
    required this.unitGroup,
    this.searchString,
  });

  @override
  List<Object?> get props => [
    units,
    unitGroup,
    searchString,
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
    required super.searchString,
  });

  @override
  List<Object?> get props => [
    unitsMarkedForConversion,
    unitIdsMarkedForConversion,
    allowUnitsToBeAddedToConversion,
    currentSourceConversionItem,
    searchString,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitsFetchedToMarkForConversion{'
        'unitsMarkedForConversion: $unitsMarkedForConversion, '
        'unitIdsMarkedForConversion: $unitIdsMarkedForConversion, '
        'allowUnitsToBeAddedToConversion: $allowUnitsToBeAddedToConversion, '
        'currentSourceConversionItem: $currentSourceConversionItem, '
        'searchString: $searchString}';
  }
}


class UnitsFetchedForUnitCreation extends UnitsFetched {
  final UnitModel? currentSelectedBaseUnit;

  const UnitsFetchedForUnitCreation({
    required super.units,
    required super.unitGroup,
    required this.currentSelectedBaseUnit,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
    currentSelectedBaseUnit,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitsFetchedForUnitCreation{'
        'currentSelectedBaseUnit: $currentSelectedBaseUnit}';
  }
}

class UnitExists extends UnitsState {
  final String unitName;

  const UnitExists({
    required this.unitName,
  });

  @override
  List<Object?> get props => [
    unitName,
  ];

  @override
  String toString() {
    return 'UnitExists{'
        'unitName: $unitName}';
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