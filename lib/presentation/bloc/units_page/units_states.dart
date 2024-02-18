import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

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
  final UnitModel? modifiedUnit;
  final bool rebuildConversion;
  final bool navigateToPage;

  const UnitsFetched({
    this.units = const [],
    required this.unitGroup,
    this.searchString,
    this.removalMode = false,
    this.markedIdsForRemoval = const [],
    this.removedIds = const [],
    this.modifiedUnit,
    this.rebuildConversion = false,
    this.navigateToPage = false,
  });

  @override
  List<Object?> get props => [
        units,
        unitGroup,
        searchString,
        removalMode,
        markedIdsForRemoval,
        removedIds,
        modifiedUnit,
        rebuildConversion,
        navigateToPage,
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
    required super.searchString,
    super.navigateToPage,
  });

  @override
  List<Object?> get props => [
        units,
        unitGroup,
        unitsMarkedForConversion,
        currentSourceConversionItem,
        searchString,
        super.props,
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
    super.navigateToPage,
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
        'searchString: $searchString, '
        'navigateToPage: $navigateToPage}';
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
    super.navigateToPage,
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
        'unitsMarkedForConversion: $unitsMarkedForConversion, '
        'navigateToPage: $navigateToPage}';
  }
}

class UnitsFetchedForUnitDetails extends UnitsFetched {
  final UnitModel? selectedArgUnit;
  final UnitModel? currentEditedUnit;

  const UnitsFetchedForUnitDetails({
    required super.units,
    required super.unitGroup,
    required this.selectedArgUnit,
    required this.currentEditedUnit,
    required super.searchString,
    super.navigateToPage,
  });

  @override
  List<Object?> get props => [
        selectedArgUnit,
        currentEditedUnit,
        super.props,
      ];

  @override
  String toString() {
    return 'UnitsFetchedForUnitDetails{'
        'selectedArgUnit: $selectedArgUnit, '
        'currentEditedUnit: $currentEditedUnit}';
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

class UnitsErrorState extends ConvertouchErrorState implements UnitsState {
  const UnitsErrorState({
    required super.exception,
    required super.lastSuccessfulState,
  });

  @override
  String toString() {
    return 'UnitsErrorState{'
        'exception: $exception}';
  }
}
