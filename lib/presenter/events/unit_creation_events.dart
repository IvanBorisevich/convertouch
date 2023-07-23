import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/events/base_event.dart';

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

  final UnitGroupModel unitGroup;
  final UnitModel? equivalentUnit;
  final List<UnitModel>? markedUnits;
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
