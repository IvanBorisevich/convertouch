import 'package:convertouch/domain/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/base_event.dart';

abstract class UnitsEvent extends ConvertouchEvent {
  const UnitsEvent();
}

class FetchUnits extends UnitsEvent {
  const FetchUnits({
    required this.unitGroupId,
    this.selectedUnit,
    this.inputValue,
    this.newMarkedUnit,
    this.markedUnits = const [],
    required this.action,
  });

  final int unitGroupId;
  final UnitModel? selectedUnit;
  final double? inputValue;
  final UnitModel? newMarkedUnit;
  final List<UnitModel> markedUnits;
  final ConvertouchAction action;

  @override
  List<Object> get props => [unitGroupId, action, markedUnits];

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
    this.markedUnits = const [],
  });

  final String unitName;
  final String unitAbbreviation;
  final UnitGroupModel unitGroup;
  final List<UnitModel> markedUnits;

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
