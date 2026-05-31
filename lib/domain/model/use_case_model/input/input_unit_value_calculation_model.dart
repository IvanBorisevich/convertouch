import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';

class InputUnitValueCalculationModel {
  final ConversionUnitValueModel unitValue;
  final ConversionSingleUnitModifyDelta? delta;
  final ConversionParamSetValueModel? paramSetValue;
  final bool alignCurrentValue;
  final bool calculateByParams;
  final String? unitGroupName;

  const InputUnitValueCalculationModel({
    required this.unitValue,
    this.delta,
    this.paramSetValue,
    this.alignCurrentValue = true,
    this.calculateByParams = false,
    this.unitGroupName,
  }) : assert(
          !calculateByParams || calculateByParams && unitGroupName != null,
          'Unit group name should be provided for calculation by params',
        );
}
