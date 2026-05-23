import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

class InputParamListValuesInitModel {
  final ConversionParamValueModel paramValue;
  final ConversionParamSetValueModel paramSetValue;

  const InputParamListValuesInitModel({
    required this.paramValue,
    required this.paramSetValue,
  });
}
