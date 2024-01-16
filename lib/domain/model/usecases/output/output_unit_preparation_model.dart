import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class OutputUnitPreparationModel {
  final UnitGroupModel? unitGroup;
  final UnitModel? baseUnit;
  final String? comment;

  const OutputUnitPreparationModel({
    required this.unitGroup,
    required this.baseUnit,
    this.comment,
  });
}