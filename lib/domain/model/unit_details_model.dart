import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:equatable/equatable.dart';

class UnitDetailsModel extends Equatable {
  final UnitGroupModel? unitGroup;
  final String unitName;
  final String unitCode;
  final String? unitValue;
  final UnitModel? argumentUnit;
  final String? argumentUnitValue;

  const UnitDetailsModel({
    this.unitGroup,
    required this.unitName,
    required this.unitCode,
    this.unitValue,
    this.argumentUnit,
    this.argumentUnitValue,
  });

  const UnitDetailsModel.empty()
      : this(
          unitName: "",
          unitCode: "",
        );

  @override
  List<Object?> get props => [
        unitGroup,
        unitName,
        unitCode,
        unitValue,
        argumentUnit,
        argumentUnitValue,
      ];

  @override
  String toString() {
    return 'UnitDetailsModel{'
        'unitGroup: $unitGroup, '
        'unitName: $unitName, '
        'unitCode: $unitCode, '
        'unitValue: $unitValue, '
        'argumentUnit: $argumentUnit, '
        'argumentUnitValue: $argumentUnitValue}';
  }
}
