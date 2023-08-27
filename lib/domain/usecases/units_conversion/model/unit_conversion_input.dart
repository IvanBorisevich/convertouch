import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';

class UnitConversionInput {
  final UnitValueModel inputUnitValue;
  final UnitModel targetUnit;

  const UnitConversionInput({
    required this.inputUnitValue,
    required this.targetUnit,
  });
}