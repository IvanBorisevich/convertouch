import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:equatable/equatable.dart';

class UnitDetailsModel extends Equatable {
  static const int unitCodeMaxLength = 5;

  final UnitGroupModel unitGroup;
  final UnitModel unitData;
  final ValueModel value;
  final UnitModel argUnit;
  final ValueModel argValue;

  const UnitDetailsModel({
    this.unitGroup = UnitGroupModel.none,
    this.unitData = UnitModel.none,
    this.value = ValueModel.one,
    this.argUnit = UnitModel.none,
    this.argValue = ValueModel.one,
  });

  @override
  List<Object?> get props => [
        unitGroup,
        unitData,
        value,
        argUnit,
        argValue,
      ];

  static UnitDetailsModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return UnitDetailsModel(
      unitGroup:
          UnitGroupModel.fromJson(json["unitGroup"]) ?? UnitGroupModel.none,
      unitData: UnitModel.fromJson(json["unitData"]) ?? UnitModel.none,
      value: ValueModel.ofString(json["valueStr"]),
      argUnit: UnitModel.fromJson(json["argUnit"]) ?? UnitModel.none,
      argValue: ValueModel.ofString(json["argValueStr"]),
    );
  }

  @override
  String toString() {
    return 'UnitDetailsModel{'
        'unitGroup: $unitGroup, '
        'unitData: $unitData, '
        'value: $value, '
        'argUnit: $argUnit, '
        'argValue: $argValue}';
  }
}
