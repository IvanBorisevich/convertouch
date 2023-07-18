import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitsMenuEvent extends ConvertouchEvent {
  const UnitsMenuEvent({
    String? triggeredBy
  }) : super(triggeredBy: triggeredBy);
}

class FetchUnits extends UnitsMenuEvent {
  const FetchUnits({
    required this.unitGroupId,
    String? triggeredBy,
  }) : super(triggeredBy: triggeredBy);

  final int unitGroupId;

  @override
  List<Object> get props => [unitGroupId];

  @override
  String toString() {
    return 'FetchUnits{unitGroupId: $unitGroupId, triggeredBy: $triggeredBy}';
  }
}

class AddUnit extends UnitsMenuEvent {
  const AddUnit({
    required this.unitName,
    required this.unitAbbreviation,
    required this.unitGroup,
    String? triggeredBy
  }) : super(triggeredBy: triggeredBy);

  final String unitName;
  final String unitAbbreviation;
  final UnitGroupModel unitGroup;

  @override
  List<Object> get props => [unitName, unitAbbreviation, unitGroup];

  @override
  String toString() {
    return 'AddUnit{'
        'unitName: $unitName, '
        'unitAbbreviation: $unitAbbreviation, '
        'unitGroup: $unitGroup,'
        'triggeredBy: $triggeredBy}';
  }
}

class SelectUnit extends UnitsMenuEvent {
  const SelectUnit({
    required this.unitId
  });

  final int unitId;

  @override
  List<Object> get props => [unitId];

  @override
  String toString() {
    return 'SelectUnit{unitId: $unitId}';
  }
}
