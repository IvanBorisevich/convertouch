import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';

class InputUnitDetailsBuildModel {
  final UnitGroupModel unitGroup;

  const InputUnitDetailsBuildModel({
    required this.unitGroup,
  });
}

class InputExistingUnitDetailsBuildModel extends InputUnitDetailsBuildModel {
  final UnitModel unit;

  const InputExistingUnitDetailsBuildModel({
    required this.unit,
    required super.unitGroup,
  });
}
