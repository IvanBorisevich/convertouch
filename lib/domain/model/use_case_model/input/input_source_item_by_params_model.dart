import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

class InputSourceItemByParamsModel {
  final ConversionUnitValueModel oldSourceUnitValue;
  final String unitGroupName;
  final ConversionParamSetValueModel? params;

  const InputSourceItemByParamsModel({
    required this.oldSourceUnitValue,
    required this.unitGroupName,
    required this.params,
  });
}
