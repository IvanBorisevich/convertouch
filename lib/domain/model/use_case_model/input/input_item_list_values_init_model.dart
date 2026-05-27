import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

abstract class InputItemListValuesInitModel<
    T extends ConversionItemValueModel> {
  final T itemValue;
  final ConversionParamSetValueModel? paramSetValue;
  final bool alignSelectedValue;

  const InputItemListValuesInitModel({
    required this.itemValue,
    this.paramSetValue,
    this.alignSelectedValue = true,
  });
}

class InputUnitListValuesInitModel
    extends InputItemListValuesInitModel<ConversionUnitValueModel> {
  const InputUnitListValuesInitModel({
    required super.itemValue,
    super.paramSetValue,
    super.alignSelectedValue,
  });
}

class InputParamListValuesInitModel
    extends InputItemListValuesInitModel<ConversionParamValueModel> {
  const InputParamListValuesInitModel({
    required super.itemValue,
    super.paramSetValue,
    super.alignSelectedValue,
  });
}
