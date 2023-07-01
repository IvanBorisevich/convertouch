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