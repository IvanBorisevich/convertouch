import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';

abstract class InputItemListValuesInitModel<
    T extends ConversionItemValueModel> {
  final T itemValue;
  final ConversionParamSetValueModel? paramSetValue;
  final bool alignSelectedValue;
  final bool alignForNull;

  const InputItemListValuesInitModel({
    required this.itemValue,
    this.paramSetValue,
    this.alignSelectedValue = true,
    this.alignForNull = false,
  });
}

class InputUnitListValuesInitModel
    extends InputItemListValuesInitModel<ConversionUnitValueModel> {
  const InputUnitListValuesInitModel({
    required super.itemValue,
    super.paramSetValue,
    super.alignSelectedValue,
    super.alignForNull,
  });
}

class InputParamListValuesInitModel
    extends InputItemListValuesInitModel<ConversionParamValueModel> {
  const InputParamListValuesInitModel({
    required super.itemValue,
    super.paramSetValue,
    super.alignSelectedValue,
    super.alignForNull,
  });
}
