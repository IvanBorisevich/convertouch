import 'package:convertouch/model/entity/unit_group_model.dart';
import 'package:convertouch/presenter/events/base_event.dart';

abstract class UnitsEvent extends ConvertouchEvent {
  const UnitsEvent();
}

class FetchUnits extends UnitsEvent {
  const FetchUnits({
    required this.unitGroupId,
    this.forPage
  });

  final int unitGroupId;
  final String? forPage;

  @override
  List<Object> get props => [unitGroupId];

  @override
  String toString() {
    return 'FetchUnits{unitGroupId: $unitGroupId, forPage: $forPage}';
  }
}

class AddUnit extends UnitsEvent {
  const AddUnit({
    required this.unitName,
    required this.unitAbbreviation,
    required this.unitGroup
  });

  final String unitName;
  final String unitAbbreviation;
  final UnitGroupModel unitGroup;

  @override
  List<Object> get props => [unitName, unitAbbreviation, unitGroup];

  @override
  String toString() {
    return 'AddUnit{'
        'unitName: $unitName, '
        'unitAbbreviation: $unitAbbreviation, '
        'unitGroup: $unitGroup}';
  }
}

class SelectUnit extends UnitsEvent {
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
