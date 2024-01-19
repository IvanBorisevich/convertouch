import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

abstract class UnitsState extends ConvertouchState {
  const UnitsState();
}

class UnitsFetching extends UnitsState {
  const UnitsFetching();

  @override
  String toString() {
    return 'UnitsFetching{}';
  }
}

class UnitsInitialState extends UnitsState {
  const UnitsInitialState();

  @override
  String toString() {
    return 'UnitsInitialState{}';
  }
}

class UnitsFetched extends UnitsState {
  final List<UnitModel> units;
  final UnitGroupModel unitGroup;
  final String? searchString;
  final bool removalMode;
  final List<int> markedIdsForRemoval;
  final List<int> removedIds;
  final int? addedId;

  const UnitsFetched({
    this.units = const [],
    required this.unitGroup,
    this.searchString,
    this.removalMode = false,
    this.markedIdsForRemoval = const [],
    this.removedIds = const [],
    this.addedId,
  });

  @override
  List<Object?> get props => [
    units,
    unitGroup,
    searchString,
    removalMode,
    markedIdsForRemoval,
    removedIds,
    addedId,
  ];

  @override
  String toString() {
    return 'UnitsFetched{'
        'units: $units, '
        'unitGroup: $unitGroup}';
  }
}

abstract class UnitsFetchedForConversion extends UnitsFetched {
  final List<UnitModel> unitsMarkedForConversion;
  final ConversionItemModel? currentSourceConversionItem;

  const UnitsFetchedForConversion({
    required super.units,
    required super.unitGroup,
    required this.unitsMarkedForConversion,
    this.currentSourceConversionItem,
    required super.searchString
  });

  @override
  List<Object?> get props => [
    units,
    unitGroup,
    unitsMarkedForConversion,
    currentSourceConversionItem,
    searchString,
  ];
}

class UnitsFetchedToMarkForConversion extends UnitsFetchedForConversion {
  final bool allowUnitsToBeAddedToConversion;

  const UnitsFetchedToMarkForConversion({
    required super.units,
    required super.unitGroup,
    required super.unitsMarkedForConversion,
    required this.allowUnitsToBeAddedToConversion,
    super.currentSourceConversionItem,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
    allowUnitsToBeAddedToConversion,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitsFetchedToMarkForConversion{'
        'unitsMarkedForConversion: $unitsMarkedForConversion, '
        'allowUnitsToBeAddedToConversion: $allowUnitsToBeAddedToConversion, '
        'currentSourceConversionItem: $currentSourceConversionItem, '
        'searchString: $searchString}';
  }
}

class UnitsFetchedForChangeInConversion extends UnitsFetchedForConversion {
  final UnitModel selectedUnit;

  const UnitsFetchedForChangeInConversion({
    required this.selectedUnit,
    required super.units,
    required super.unitGroup,
    required super.unitsMarkedForConversion,
    super.currentSourceConversionItem,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
    selectedUnit,
    super.props,
  ];

  @override
  String toString() {
    return 'UnitsFetchedForChangeInConversion{'
        'selectedUnit: $selectedUnit, '
        'unitsMarkedForConversion: $unitsMarkedForConversion}';
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