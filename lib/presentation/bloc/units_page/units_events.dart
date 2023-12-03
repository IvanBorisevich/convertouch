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

class OpenUnitsToSelectEquivalentUnit extends UnitsEvent {
  final UnitModel? currentSelectedEquivalentUnit;

  const OpenUnitsToSelectEquivalentUnit({
    required this.currentSelectedEquivalentUnit,
  });

  @override
  String toString() {
    return 'OpenUnitsToSelectEquivalentUnit{'
        'currentSelectedEquivalentUnit: $currentSelectedEquivalentUnit}';
  }
}

class PrepareUnitCreation extends UnitsEvent {
  final int unitGroupId;
  final UnitModel? equivalentUnit;

  const PrepareUnitCreation({
    required this.unitGroupId,
    this.equivalentUnit,
  });

  @override
  List<Object?> get props => [
    unitGroupId,
    equivalentUnit,
  ];

  @override
  String toString() {
    return 'PrepareUnitCreation{'
        'unitGroupId: $unitGroupId, '
        'equivalentUnit: $equivalentUnit}';
  }
}

class RemoveUnits extends UnitsEvent {
  final List<int> ids;

  const RemoveUnits({
    required this.ids,
  });

  @override
  List<Object> get props => [
    ids,
  ];

  @override
  String toString() {
    return 'RemoveUnits{'
        'ids: $ids}';
  }
}
