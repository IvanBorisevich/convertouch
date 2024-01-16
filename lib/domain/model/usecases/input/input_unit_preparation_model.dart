import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputUnitPreparationModel {
  final UnitModel? baseUnit;
  final UnitGroupModel? unitGroup;

  const InputUnitPreparationModel({
    required this.baseUnit,
    required this.unitGroup,
  });
}