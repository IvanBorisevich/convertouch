import 'package:convertouch/domain/model/unit_model.dart';

class UnitAddingInput {
  final UnitModel newUnit;
  final double? newUnitValue;
  final UnitModel? baseUnit;
  final double? baseUnitValue;

  const UnitAddingInput({
    required this.newUnit,
    required this.newUnitValue,
    this.baseUnit,
    this.baseUnitValue,
  });
}