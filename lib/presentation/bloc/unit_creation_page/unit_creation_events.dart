import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:equatable/equatable.dart';

abstract class UnitCreationEvent extends Equatable {
  const UnitCreationEvent();
}

class PrepareUnitCreation extends UnitCreationEvent {
  final UnitGroupModel? unitGroup;
  final UnitModel? baseUnit;

  const PrepareUnitCreation({
    required this.unitGroup,
    required this.baseUnit,
  });

  @override
  List<Object?> get props => [
    unitGroup,
    baseUnit,
  ];

  @override
  String toString() {
    return 'PrepareUnitCreation{'
        'unitGroup: $unitGroup, '
        'baseUnit: $baseUnit}';
  }
}
