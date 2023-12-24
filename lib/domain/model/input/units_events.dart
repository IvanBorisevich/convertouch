import 'package:convertouch/domain/model/input/abstract_event.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';

abstract class UnitsEvent extends ConvertouchEvent {
  const UnitsEvent();
}

class FetchUnits extends UnitsEvent {
  final UnitGroupModel unitGroup;
  final String? searchString;

  const FetchUnits({
    required this.unitGroup,
    required this.searchString,
  });

  @override
  List<Object?> get props => [
    unitGroup,
    searchString,
  ];

  @override
  String toString() {
    return 'FetchUnits{'
        'unitGroup: $unitGroup,'
        'searchString: $searchString}';
  }
}

class FetchUnitsToMarkForConversion extends FetchUnits {
  final List<UnitModel>? unitsAlreadyMarkedForConversion;
  final UnitModel? unitNewlyMarkedForConversion;
  final ConversionItemModel? currentSourceConversionItem;

  const FetchUnitsToMarkForConversion({
    required super.unitGroup,
    this.unitsAlreadyMarkedForConversion,
    this.unitNewlyMarkedForConversion,
    this.currentSourceConversionItem,
    required super.searchString,
  });

  @override
  List<Object?> get props => [
    unitNewlyMarkedForConversion,
    unitsAlreadyMarkedForConversion,
    currentSourceConversionItem,
    super.props,
  ];

  @override
  String toString() {
    return 'FetchUnitsToMarkForConversion{'
        'unitNewlyMarkedForConversion: $unitNewlyMarkedForConversion, '
        'unitsAlreadyMarkedForConversion: $unitsAlreadyMarkedForConversion, '
        'currentSourceConversionItem: $currentSourceConversionItem, '
        '${super.toString()}}';
  }
}

class FetchUnitsForUnitCreation extends FetchUnits {
  final UnitModel? currentSelectedBaseUnit;

  const FetchUnitsForUnitCreation({
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
    return 'FetchUnitsForUnitCreation{'
        'currentSelectedBaseUnit: $currentSelectedBaseUnit,'
        '${super.toString()}}';
  }
}

class AddUnit extends UnitsEvent {
  final UnitModel newUnit;
  final String? newUnitValue;
  final UnitModel? baseUnit;
  final String? baseUnitValue;
  final UnitGroupModel unitGroup;

  const AddUnit({
    required this.newUnit,
    required this.newUnitValue,
    required this.baseUnit,
    required this.baseUnitValue,
    required this.unitGroup,
  });

  @override
  List<Object?> get props => [
    newUnit,
    newUnitValue,
    baseUnit,
    baseUnitValue,
    unitGroup,
  ];

  @override
  String toString() {
    return 'AddUnit{'
        'newUnit: $newUnit, '
        'newUnitValue: $newUnitValue, '
        'baseUnit: $baseUnit, '
        'baseUnitValue: $baseUnitValue, '
        'unitGroup: $unitGroup}';
  }
}

class RemoveUnits extends UnitsEvent {
  final List<int> ids;
  final UnitGroupModel unitGroup;

  const RemoveUnits({
    required this.ids,
    required this.unitGroup,
  });

  @override
  List<Object> get props => [
    ids,
    unitGroup,
  ];

  @override
  String toString() {
    return 'RemoveUnits{'
        'ids: $ids, '
        'unitGroup: $unitGroup}';
  }
}
