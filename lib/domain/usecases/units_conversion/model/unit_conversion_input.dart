import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';

class UnitConversionInput {
  final UnitValueModel inputUnitValue;
  final UnitModel targetUnit;
  final UnitGroupModel unitGroup;

  const UnitConversionInput({
    required this.inputUnitValue,
    required this.targetUnit,
    required this.unitGroup,
  });
}