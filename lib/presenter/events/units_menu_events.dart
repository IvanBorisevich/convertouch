import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitsMenuEvent extends ConvertouchEvent {
  const UnitsMenuEvent();
}

class FetchUnits extends UnitsMenuEvent {
  const FetchUnits({
    required this.unitGroupId,
    this.isBackNavigation = false,
  });

  final int unitGroupId;
  final bool isBackNavigation;

  @override
  List<Object> get props => [unitGroupId, isBackNavigation];

  @override
  String toString() {
    return 'FetchUnits{'
        'unitGroupId: $unitGroupId, '
        'isBackNavigation: $isBackNavigation}';
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
