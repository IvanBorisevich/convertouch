import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';

abstract class InputItemListValuesInitModel<M extends ItemValueModel> {
  final M itemValue;
  final ConversionParamSetValueModel? paramSetValue;
  final bool alignSelectedValue;
  final bool keepSelectedValueIfNotInList;
  final bool fetchListValues;
  final void Function(M itemValue)? onListValuesFetched;

  const InputItemListValuesInitModel({
    required this.itemValue,
    this.paramSetValue,
    this.alignSelectedValue = true,
    this.fetchListValues = true,
    this.keepSelectedValueIfNotInList = false,
    this.onListValuesFetched,
  });
}

class InputUnitListValuesInitModel
    extends InputItemListValuesInitModel<ConversionUnitValueModel> {
  const InputUnitListValuesInitModel({
    required super.itemValue,
    super.paramSetValue,
    super.alignSelectedValue,
    super.fetchListValues,
    super.keepSelectedValueIfNotInList,
    super.onListValuesFetched,
  });
}

class InputParamListValuesInitModel
    extends InputItemListValuesInitModel<ConversionParamValueModel> {
  const InputParamListValuesInitModel({
    required super.itemValue,
    super.paramSetValue,
    super.alignSelectedValue,
    super.fetchListValues,
    super.keepSelectedValueIfNotInList,
    super.onListValuesFetched,
  });
}
