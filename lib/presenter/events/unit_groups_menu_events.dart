import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitGroupsMenuEvent extends ConvertouchEvent {
  const UnitGroupsMenuEvent({
    String? triggeredBy
  }) : super(triggeredBy: triggeredBy);
}

class FetchUnitGroups extends UnitGroupsMenuEvent {
  const FetchUnitGroups({
    String? triggeredBy
  }) : super(triggeredBy: triggeredBy);

  @override
  String toString() {
    return 'FetchUnitGroups{triggeredBy: $triggeredBy}';
  }
}

class AddUnitGroup extends UnitGroupsMenuEvent {
  const AddUnitGroup({
    required this.unitGroupName,
    String? triggeredBy,
  }) : super(triggeredBy: triggeredBy);

  final String unitGroupName;

  @override
  List<Object> get props => [unitGroupName];

  @override
  String toString() {
    return 'AddUnitGroup{'
        'unitGroupName: $unitGroupName, '
        'triggeredBy: $triggeredBy}';
  }
}

class SelectUnitGroup extends UnitGroupsMenuEvent {
  const SelectUnitGroup({
    required this.unitGroup,
    String? triggeredBy,
  });

  final UnitGroupModel unitGroup;

  @override
  List<Object> get props => [unitGroup];

  @override
  String toString() {
    return 'SelectUnitGroup{unitGroup: $unitGroup, triggeredBy: $triggeredBy}';
  }
}