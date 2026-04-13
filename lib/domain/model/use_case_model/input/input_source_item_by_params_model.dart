import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';

class InputSourceItemByParamsModel {
  final ConversionUnitValueModel oldSourceUnitValue;
  final UnitGroupModel unitGroup;
  final ConversionParamSetValueModel? params;

  const InputSourceItemByParamsModel({
    required this.oldSourceUnitValue,
    required this.unitGroup,
    required this.params,
  });
}
