import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';

class InputParamSetValueCalculationModel {
  final ConversionParamSetValueModel paramSetValue;
  final ConversionSingleParamModifyDelta? delta;
  final ConversionUnitValueModel? srcUnitValue;
  final String? unitGroupName;
  final bool alignCurrentValues;
  final bool listValuesAutoFetch;
  final bool keepSelectedValuesIfNotInList;
  final bool enableFirstCalculableParamIfNoCalculatedEnabled;
  final void Function(ConversionParamValueModel)? onParamValueUpdated;

  const InputParamSetValueCalculationModel({
    required this.paramSetValue,
    this.delta,
    this.srcUnitValue,
    this.unitGroupName,
    required this.alignCurrentValues,
    this.listValuesAutoFetch = true,
    this.keepSelectedValuesIfNotInList = false,
    required this.enableFirstCalculableParamIfNoCalculatedEnabled,
    this.onParamValueUpdated,
  });
}
