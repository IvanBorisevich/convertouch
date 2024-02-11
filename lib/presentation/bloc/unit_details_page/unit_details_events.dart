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

class ChangeGroupInUnitDetails extends UnitDetailsEvent {
  final UnitGroupModel unitGroup;

  const ChangeGroupInUnitDetails({
    required this.unitGroup,
  });

  @override
  List<Object?> get props => [
        unitGroup,
      ];

  @override
  String toString() {
    return 'ChangeGroupInUnitDetails{'
        'unitGroup: $unitGroup}';
  }
}

class ChangeArgumentUnitInUnitDetails extends UnitDetailsEvent {
  final UnitModel argumentUnit;

  const ChangeArgumentUnitInUnitDetails({
    required this.argumentUnit,
  });

  @override
  List<Object?> get props => [
        argumentUnit,
      ];

  @override
  String toString() {
    return 'UpdateArgumentUnitInUnitDetails{'
        'argumentUnit: $argumentUnit}';
  }
}

abstract class UpdateUnitTextValues extends UnitDetailsEvent {
  final String newValue;

  const UpdateUnitTextValues({
    required this.newValue,
  });

  @override
  List<Object?> get props => [
        newValue,
      ];
}

class UpdateUnitNameInUnitDetails extends UpdateUnitTextValues {
  const UpdateUnitNameInUnitDetails({
    required super.newValue,
  });

  @override
  String toString() {
    return 'UpdateUnitNameInUnitDetails{'
        'newValue: $newValue}';
  }
}

class UpdateUnitCodeInUnitDetails extends UpdateUnitTextValues {
  const UpdateUnitCodeInUnitDetails({
    required super.newValue,
  });

  @override
  String toString() {
    return 'UpdateUnitCodeInUnitDetails{'
        'newValue: $newValue}';
  }
}

class UpdateUnitValueInUnitDetails extends UpdateUnitTextValues {
  const UpdateUnitValueInUnitDetails({
    required super.newValue,
  });

  @override
  String toString() {
    return 'UpdateUnitValueInUnitDetails{'
        'newValue: $newValue}';
  }
}

class UpdateArgumentUnitValueInUnitDetails extends UpdateUnitTextValues {
  const UpdateArgumentUnitValueInUnitDetails({
    required super.newValue,
  });

  @override
  String toString() {
    return 'UpdateArgumentUnitValueInUnitDetails{'
        'newValue: $newValue}';
  }
}
