import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitsMenuEvent extends ConvertouchEvent {
  const UnitsMenuEvent();
}

class FetchUnits extends UnitsMenuEvent {
  const FetchUnits({
    required this.unitGroupId,
    this.triggeredBy,
  });

  final int unitGroupId;
  final String? triggeredBy;

  @override
  List<Object> get props => [unitGroupId];

  @override
  String toString() {
    return 'FetchUnits{unitGroupId: $unitGroupId, triggeredBy: $triggeredBy}';
  }
}

class AddUnit extends UnitsMenuEvent {
  const AddUnit(
      {required this.unitName,
      required this.unitAbbreviation,
      required this.unitGroupId});

  final String unitName;
  final String unitAbbreviation;
  final int unitGroupId;

  @override
  List<Object> get props => [unitName, unitAbbreviation, unitGroupId];

  @override
  String toString() {
    return 'AddUnit{'
        'unitName: $unitName, '
        'unitAbbreviation: $unitAbbreviation, '
        'unitGroupId: $unitGroupId}';
  }
}
