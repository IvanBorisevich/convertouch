import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';

class InputParamSetValueCalculationModel {
  final ConversionParamSetValueModel paramSetValue;
  final ConversionParamsModifyDelta? delta;
  final int? startParamId;
  final ConversionUnitValueModel? srcUnitValue;
  final UnitGroupModel conversionGroup;
  final bool enableFirstCalculableParamIfNoCalculatedEnabled;
  final void Function(ConversionParamValueModel)? onParamValueUpdated;

  const InputParamSetValueCalculationModel({
    required this.paramSetValue,
    required this.conversionGroup,
    this.delta,
    required this.startParamId,
    this.srcUnitValue,
    required this.enableFirstCalculableParamIfNoCalculatedEnabled,
    this.onParamValueUpdated,
  });
}
