import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
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

class FetchUnitsForConversion extends UnitsEvent {
  final List<UnitModel>? unitsAlreadyMarkedForConversion;
  final UnitModel? unitNewlyMarkedForConversion;

  const FetchUnitsForConversion({
    this.unitsAlreadyMarkedForConversion,
    this.unitNewlyMarkedForConversion,
  });

  @override
  List<Object?> get props => [
    unitNewlyMarkedForConversion,
    unitsAlreadyMarkedForConversion,
    super.props,
  ];

  @override
  String toString() {
    return 'FetchUnitsForConversion{'
        'unitNewlyMarkedForConversion: $unitNewlyMarkedForConversion, '
        'unitsAlreadyMarkedForConversion: $unitsAlreadyMarkedForConversion'
        '}';
  }
}

class FetchUnitsForEquivalentUnitSelection extends UnitsEvent {
  final UnitModel? selectedEquivalentUnit;

  const FetchUnitsForEquivalentUnitSelection({
    required this.selectedEquivalentUnit,
  });

  @override
  String toString() {
    return 'FetchUnitsForEquivalentUnitSelection{'
        'selectedEquivalentUnit: $selectedEquivalentUnit}';
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
