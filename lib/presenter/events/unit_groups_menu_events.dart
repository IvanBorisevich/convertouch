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