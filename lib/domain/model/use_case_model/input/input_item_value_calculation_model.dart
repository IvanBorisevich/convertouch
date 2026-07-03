import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';

abstract class _InputItemValueCalculationModel<M extends ItemValueModel> {
  final M itemValue;
  final String unitGroupName;

  const _InputItemValueCalculationModel({
    required this.itemValue,
    required this.unitGroupName,
  });
}

class InputUnitValueCalculationModel
    extends _InputItemValueCalculationModel<ConversionUnitValueModel> {
  final ConversionSingleUnitModifyDelta? delta;
  final ConversionParamSetValueModel? paramSetValue;
  final bool calculateByParams;

  const InputUnitValueCalculationModel({
    required super.itemValue,
    required super.unitGroupName,
    this.delta,
    this.paramSetValue,
    this.calculateByParams = false,
  });
}

class InputParamValueCalculationModel
    extends _InputItemValueCalculationModel<ConversionParamValueModel> {
  final ConversionSingleParamModifyDelta? delta;
  final ConversionParamSetValueModel paramSetValue;
  final ConversionUnitValueModel? srcUnitValue;

  const InputParamValueCalculationModel({
    required super.itemValue,
    required super.unitGroupName,
    required this.paramSetValue,
    this.delta,
    this.srcUnitValue,
  });
}
