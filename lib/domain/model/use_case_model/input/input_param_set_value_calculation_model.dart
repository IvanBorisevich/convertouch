import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';

class InputParamSetValueCalculationModel {
  final ConversionParamSetValueModel paramSetValue;
  final ConversionSingleParamModifyDelta? delta;
  final ConversionUnitValueModel? srcUnitValue;
  final String? unitGroupName;
  final bool alignCurrentValues;

  const InputParamSetValueCalculationModel({
    required this.paramSetValue,
    this.delta,
    this.srcUnitValue,
    this.unitGroupName,
    this.alignCurrentValues = true,
  });
}
