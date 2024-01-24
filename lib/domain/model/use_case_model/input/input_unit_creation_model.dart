import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputUnitCreationModel {
  final UnitGroupModel unitGroup;
  final String newUnitName;
  final String newUnitCode;
  final String? newUnitValue;
  final String? baseUnitValue;
  final UnitModel? baseUnit;

  const InputUnitCreationModel({
    required this.unitGroup,
    required this.newUnitName,
    required this.newUnitCode,
    this.newUnitValue,
    this.baseUnitValue,
    this.baseUnit,
  });

  @override
  String toString() {
    return 'InputUnitCreationModel{'
        'unitGroup: $unitGroup, '
        'newUnitName: $newUnitName, '
        'newUnitCode: $newUnitCode, '
        'newUnitValue: $newUnitValue, '
        'baseUnitValue: $baseUnitValue, '
        'baseUnit: $baseUnit}';
  }
}