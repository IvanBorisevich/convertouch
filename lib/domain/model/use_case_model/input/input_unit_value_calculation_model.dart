import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';

class InputUnitValueCalculationModel {
  final ConversionUnitValueModel unitValue;
  final ConversionSingleUnitModifyDelta? delta;
  final ConversionParamSetValueModel? paramSetValue;
  final bool alignCurrentValue;

  const InputUnitValueCalculationModel({
    required this.unitValue,
    this.delta,
    this.paramSetValue,
    this.alignCurrentValue = true,
  });
}
