import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';

class InputParamValueCalculationModel {
  final ConversionParamValueModel paramValue;
  final ConversionParamSetValueModel paramSetValue;
  final ConversionSingleParamModifyDelta? delta;
  final ConversionUnitValueModel? srcUnitValue;
  final String? unitGroupName;
  final bool alignCurrentValue;

  const InputParamValueCalculationModel({
    required this.paramValue,
    required this.paramSetValue,
    this.delta,
    this.srcUnitValue,
    this.unitGroupName,
    this.alignCurrentValue = true,
  });
}
