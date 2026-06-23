import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';

abstract class _InputItemValueCalculationModel<M extends ItemValueModel> {
  final M itemValue;
  final String? unitGroupName;
  final bool alignCurrentValue;
  final bool listValuesAutoFetch;
  final bool listValuesAsyncFetch;
  final bool keepSelectedValueIfNotInList;
  final void Function(M)? onItemValueUpdated;

  const _InputItemValueCalculationModel({
    required this.itemValue,
    this.unitGroupName,
    this.alignCurrentValue = true,
    this.listValuesAutoFetch = true,
    this.listValuesAsyncFetch = false,
    this.keepSelectedValueIfNotInList = false,
    this.onItemValueUpdated,
  });
}

class InputUnitValueCalculationModel
    extends _InputItemValueCalculationModel<ConversionUnitValueModel> {
  final ConversionSingleUnitModifyDelta? delta;
  final ConversionParamSetValueModel? paramSetValue;
  final bool calculateByParams;

  const InputUnitValueCalculationModel({
    required super.itemValue,
    this.delta,
    this.paramSetValue,
    this.calculateByParams = false,
    super.unitGroupName,
    super.alignCurrentValue,
    super.listValuesAutoFetch,
    super.listValuesAsyncFetch,
    super.keepSelectedValueIfNotInList,
    super.onItemValueUpdated,
  }) : assert(
          !calculateByParams || calculateByParams && unitGroupName != null,
          'Unit group name should be provided for calculation by params',
        );
}

class InputParamValueCalculationModel
    extends _InputItemValueCalculationModel<ConversionParamValueModel> {
  final ConversionSingleParamModifyDelta? delta;
  final ConversionParamSetValueModel paramSetValue;
  final ConversionUnitValueModel? srcUnitValue;

  const InputParamValueCalculationModel({
    required super.itemValue,
    required this.paramSetValue,
    this.delta,
    this.srcUnitValue,
    super.unitGroupName,
    super.alignCurrentValue,
    super.listValuesAutoFetch,
    super.listValuesAsyncFetch,
    super.keepSelectedValueIfNotInList,
    super.onItemValueUpdated,
  });
}
