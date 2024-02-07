import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class UnitDetailsEvent extends ConvertouchEvent {
  const UnitDetailsEvent();
}

class GetNewUnitDetails extends UnitDetailsEvent {
  final UnitGroupModel? unitGroup;

  const GetNewUnitDetails({
    this.unitGroup,
  });

  @override
  List<Object?> get props => [
        unitGroup,
      ];

  @override
  String toString() {
    return 'GetNewUnitDetails{unitGroup: $unitGroup}';
  }
}

class GetExistingUnitDetails extends UnitDetailsEvent {
  final UnitModel unit;
  final UnitGroupModel unitGroup;

  const GetExistingUnitDetails({
    required this.unit,
    required this.unitGroup,
  });

  @override
  List<Object?> get props => [
        unit,
        unitGroup,
      ];

  @override
  String toString() {
    return 'GetExistingUnitDetails{'
        'unit: $unit, '
        'unitGroup: $unitGroup}';
  }
}

class UpdateGroupInUnitDetails extends UnitDetailsEvent {
  final UnitGroupModel unitGroup;

  const UpdateGroupInUnitDetails({
    required this.unitGroup,
  });

  @override
  List<Object?> get props => [
        unitGroup,
      ];

  @override
  String toString() {
    return 'UpdateGroupInUnitDetails{unitGroup: $unitGroup}';
  }
}

class UpdateArgumentUnitInUnitDetails extends UnitDetailsEvent {
  final UnitModel argumentUnit;

  const UpdateArgumentUnitInUnitDetails({
    required this.argumentUnit,
  });

  @override
  List<Object?> get props => [
        argumentUnit,
      ];

  @override
  String toString() {
    return 'UpdateArgumentUnitInUnitDetails{argumentUnit: $argumentUnit}';
  }
}
