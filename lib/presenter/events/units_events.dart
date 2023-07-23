import 'package:convertouch/model/constant.dart';
import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/model/entity/unit_model.dart';
import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitsEvent extends ConvertouchEvent {
  const UnitsEvent();
}

class FetchUnits extends UnitsEvent {
  const FetchUnits({
    required this.unitGroupId,
    this.selectedUnit,
    this.inputValue,
    this.newMarkedUnit,
    this.markedUnits,
    required this.action,
  });

  final int unitGroupId;
  final UnitModel? selectedUnit;
  final String? inputValue;
  final UnitModel? newMarkedUnit;
  final List<UnitModel>? markedUnits;
  final ConvertouchAction action;

  @override
  List<Object> get props => [unitGroupId, action];

  @override
  String toString() {
    return 'FetchUnits{'
        'unitGroupId: $unitGroupId, '
        'selectedUnit: $selectedUnit, '
        'inputValue: $inputValue, '
        'newMarkedUnit: $newMarkedUnit, '
        'markedUnits: $markedUnits, '
        'action: $action}';
  }
}

class AddUnit extends UnitsEvent {
  const AddUnit({
    required this.unitName,
    required this.unitAbbreviation,
    required this.unitGroup,
    this.markedUnits,
  });

  final String unitName;
  final String unitAbbreviation;
  final UnitGroupModel unitGroup;
  final List<UnitModel>? markedUnits;

  @override
  List<Object> get props => [unitName, unitAbbreviation, unitGroup];

  @override
  String toString() {
    return 'AddUnit{'
        'unitName: $unitName, '
        'unitAbbreviation: $unitAbbreviation, '
        'unitGroup: $unitGroup, '
        'markedUnits: $markedUnits}';
  }
}
