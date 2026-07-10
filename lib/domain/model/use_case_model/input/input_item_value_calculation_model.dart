import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';

abstract class InputItemValueCalculationModel<M extends ItemValueModel,
    D extends ConversionModifyDelta> {
  final M itemValue;
  final D? delta;
  final UnitGroupModel conversionGroup;
  final bool initDefaultNonListValueIfEmpty;

  const InputItemValueCalculationModel({
    required this.itemValue,
    this.delta,
    required this.conversionGroup,
    this.initDefaultNonListValueIfEmpty = true,
  });
}

class InputUnitValueCalculationModel extends InputItemValueCalculationModel<
    ConversionUnitValueModel, ConversionUnitValuesModifyDelta> {
  final ConversionParamSetValueModel? paramSetValue;

  const InputUnitValueCalculationModel({
    required super.itemValue,
    super.delta,
    required super.conversionGroup,
    this.paramSetValue,
    super.initDefaultNonListValueIfEmpty,
  });
}

class InputParamValueCalculationModel extends InputItemValueCalculationModel<
    ConversionParamValueModel, ConversionParamsModifyDelta> {
  final ConversionParamSetValueModel paramSetValue;
  final ConversionUnitValueModel? srcUnitValue;

  const InputParamValueCalculationModel({
    required super.itemValue,
    super.delta,
    required super.conversionGroup,
    required this.paramSetValue,
    this.srcUnitValue,
    super.initDefaultNonListValueIfEmpty,
  });
}
