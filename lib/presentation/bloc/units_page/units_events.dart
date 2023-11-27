import 'package:convertouch/domain/model/unit_model.dart';
import 'package:equatable/equatable.dart';

abstract class UnitsEvent extends Equatable {
  const UnitsEvent();

  @override
  List<Object?> get props => [];
}

class FetchUnitsOfGroup extends UnitsEvent {
  final int unitGroupId;

  const FetchUnitsOfGroup({
    required this.unitGroupId,
  });

  @override
  List<Object?> get props => [
    unitGroupId,
  ];

  @override
  String toString() {
    return 'FetchUnitsOfGroup{'
        'unitGroupId: $unitGroupId}';
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
