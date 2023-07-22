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
    this.newMarkedUnitId,
    this.markedUnitIds,
    this.forPage
  });

  final int unitGroupId;
  final UnitModel? selectedUnit;
  final int? newMarkedUnitId;
  final List<int>? markedUnitIds;
  final String? forPage;

  @override
  List<Object> get props => [unitGroupId];

  @override
  String toString() {
    return 'FetchUnits{'
        'unitGroupId: $unitGroupId, '
        'selectedUnit: $selectedUnit, '
        'newMarkedUnitId: $newMarkedUnitId, '
        'markedUnitIds: $markedUnitIds, '
        'forPage: $forPage}';
  }
}

class AddUnit extends UnitsEvent {
  const AddUnit({
    required this.unitName,
    required this.unitAbbreviation,
    required this.unitGroup,
    this.markedUnitIds,
  });

  final String unitName;
  final String unitAbbreviation;
  final UnitGroupModel unitGroup;
  final List<int>? markedUnitIds;

  @override
  List<Object> get props => [unitName, unitAbbreviation, unitGroup];

  @override
  String toString() {
    return 'AddUnit{'
        'unitName: $unitName, '
        'unitAbbreviation: $unitAbbreviation, '
        'unitGroup: $unitGroup, '
        'markedUnitIds: $markedUnitIds}';
  }
}
