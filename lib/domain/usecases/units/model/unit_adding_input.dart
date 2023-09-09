import 'package:convertouch/domain/model/unit_model.dart';

class UnitAddingInput {
  final UnitModel newUnit;
  final double newUnitValue;
  final UnitModel equivalentUnit;
  final double equivalentUnitValue;

  const UnitAddingInput({
    required this.newUnit,
    required this.newUnitValue,
    required this.equivalentUnit,
    required this.equivalentUnitValue,
  });
}