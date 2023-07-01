import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitGroupsMenuEvent extends ConvertouchEvent {
  const UnitGroupsMenuEvent();
}

class FetchUnitGroups extends UnitGroupsMenuEvent {
  const FetchUnitGroups({
    this.firstTime = false
  });

  final bool firstTime;

  @override
  List<Object> get props => [
    firstTime
  ];

  @override
  String toString() {
    return 'FetchUnitGroups{firstTime: $firstTime}';
  }
}