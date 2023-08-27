import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class UnitCreationEvent extends ConvertouchEvent {
  const UnitCreationEvent();
}

class PrepareUnitCreation extends UnitCreationEvent {
  const PrepareUnitCreation({
    required this.unitGroup,
    this.equivalentUnit,
    this.markedUnits = const [],
    required this.action,
  });

  final UnitGroupModel unitGroup;
  final UnitModel? equivalentUnit;
  final List<UnitModel> markedUnits;
  final ConvertouchAction action;

  @override
  List<Object> get props => [unitGroup, action, markedUnits];

  @override
  String toString() {
    return 'PrepareUnitCreation{'
        'unitGroup: $unitGroup, '
        'equivalentUnit: $equivalentUnit, '
        'markedUnits: $markedUnits, '
        'action: $action}';
  }
}
