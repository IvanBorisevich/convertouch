import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/entities/unit_group_entity.dart';
import 'package:convertouch/domain/entities/unit_entity.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class UnitCreationEvent extends ConvertouchEvent {
  const UnitCreationEvent();
}

class PrepareUnitCreation extends UnitCreationEvent {
  const PrepareUnitCreation({
    required this.unitGroup,
    this.equivalentUnit,
    this.markedUnits,
    required this.action,
  });

  final UnitGroupEntity unitGroup;
  final UnitEntity? equivalentUnit;
  final List<UnitEntity>? markedUnits;
  final ConvertouchAction action;

  @override
  List<Object> get props => [unitGroup, action];

  @override
  String toString() {
    return 'PrepareUnitCreation{'
        'unitGroup: $unitGroup, '
        'equivalentUnit: $equivalentUnit, '
        'markedUnits: $markedUnits, '
        'action: $action}';
  }
}
