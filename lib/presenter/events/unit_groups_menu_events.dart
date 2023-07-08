import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitGroupsMenuEvent extends ConvertouchEvent {
  const UnitGroupsMenuEvent();
}

class FetchUnitGroups extends UnitGroupsMenuEvent {
  const FetchUnitGroups();

  @override
  String toString() {
    return 'FetchUnitGroups{}';
  }
}

class AddUnitGroup extends UnitGroupsMenuEvent {
  const AddUnitGroup({required this.unitGroupName});

  final String unitGroupName;

  @override
  List<Object> get props => [unitGroupName];

  @override
  String toString() {
    return 'AddUnitGroup{unitGroupName: $unitGroupName}';
  }
}