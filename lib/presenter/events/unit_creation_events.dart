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
    this.markedUnitIds,
    this.initial = false,
  });

  final UnitGroupModel unitGroup;
  final UnitModel? equivalentUnit;
  final List<int>? markedUnitIds;
  final bool initial;

  @override
  List<Object> get props => [unitGroup, initial];

  @override
  String toString() {
    return 'PrepareUnitCreation{'
        'unitGroup: $unitGroup, '
        'equivalentUnit: $equivalentUnit, '
        'markedUnitIds: $markedUnitIds, '
        'initial: $initial}';
  }
}
