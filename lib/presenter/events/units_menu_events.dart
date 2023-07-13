import 'package:convertouch/model/constant.dart';
import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitsMenuEvent extends ConvertouchEvent {
  const UnitsMenuEvent();
}

class FetchUnits extends UnitsMenuEvent {
  const FetchUnits({
    required this.unitGroupId,
    this.navigationAction,
  });

  final int unitGroupId;
  final NavigationAction? navigationAction;

  @override
  List<Object> get props => [unitGroupId];

  @override
  String toString() {
    return 'FetchUnits{'
        'unitGroupId: $unitGroupId}';
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
