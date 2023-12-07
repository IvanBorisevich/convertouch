import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:equatable/equatable.dart';

abstract class UnitsEvent extends Equatable {
  const UnitsEvent();

  @override
  List<Object?> get props => [];
}

class FetchUnits extends UnitsEvent {
  final UnitGroupModel unitGroup;

  const FetchUnits({
    required this.unitGroup,
  });

  @override
  List<Object?> get props => [
    unitGroup,
  ];

  @override
  String toString() {
    return 'FetchUnits{'
        'unitGroup: $unitGroup}';
  }
}

class FetchUnitsToMarkForConversion extends FetchUnits {
  final List<UnitModel>? unitsAlreadyMarkedForConversion;
  final UnitModel? unitNewlyMarkedForConversion;
  final UnitValueModel? currentSourceConversionItem;

  const FetchUnitsToMarkForConversion({
    required super.unitGroup,
    this.unitsAlreadyMarkedForConversion,
    this.unitNewlyMarkedForConversion,
    this.currentSourceConversionItem,
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
        'currentSourceConversionItem: $currentSourceConversionItem'
        '}';
  }
}

class FetchUnitsForUnitCreation extends FetchUnits {
  final UnitModel? currentSelectedBaseUnit;

  const FetchUnitsForUnitCreation({
    required super.unitGroup,
    required this.currentSelectedBaseUnit,
  });

  @override
  List<Object?> get props => [
    currentSelectedBaseUnit,
    super.props,
  ];

  @override
  String toString() {
    return 'FetchUnitsForUnitCreation{'
        'currentSelectedBaseUnit: $currentSelectedBaseUnit}';
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
