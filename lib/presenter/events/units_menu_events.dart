import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitsMenuEvent extends ConvertouchEvent {
  const UnitsMenuEvent();
}


class FetchUnits extends UnitsMenuEvent {
  const FetchUnits({
    required this.unitGroupId
  });

  final int unitGroupId;

  @override
  List<Object> get props => [
    unitGroupId
  ];

  @override
  String toString() {
    return 'FetchUnits{unitGroupId: $unitGroupId}';
  }
}

class SelectUnits extends UnitsMenuEvent {
  const SelectUnits({
    required this.unitIds
  });

  final List<int> unitIds;

  @override
  List<Object> get props => [
    unitIds
  ];

  @override
  String toString() {
    return 'SelectUnits{unitIds: $unitIds}';
  }
}