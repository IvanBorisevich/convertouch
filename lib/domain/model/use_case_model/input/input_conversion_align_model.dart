import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';

class InputConversionAlignModel {
  final ConversionModel conversion;
  final void Function(ConversionParamValueModel)? onParamValueUpdated;
  final int? paramIdToRefreshListValues;
  final bool alignParams;
  final bool alignUnits;
  final bool listValuesAutoFetch;

  const InputConversionAlignModel({
    required this.conversion,
    this.onParamValueUpdated,
    this.paramIdToRefreshListValues,
    this.alignParams = true,
    this.alignUnits = true,
    this.listValuesAutoFetch = true,
  });
}
