import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';

class InputConversionAlignModel {
  final ConversionModel conversion;
  final void Function(ConversionParamValueModel)? onParamValueUpdated;
  final void Function(ConversionUnitValueModel, bool)? onUnitValueUpdated;
  final void Function(ConversionModel)? onConversionParamsAligned;
  final void Function(ConversionModel)? onConversionUnitValuesAligned;
  final int? paramIdToRefreshListValues;
  final bool alignParams;
  final bool alignUnits;
  final bool asyncAlign;
  final bool alignCurrentValues;
  final bool fetchListValues;

  const InputConversionAlignModel({
    required this.conversion,
    this.onParamValueUpdated,
    this.onUnitValueUpdated,
    this.onConversionParamsAligned,
    this.onConversionUnitValuesAligned,
    this.paramIdToRefreshListValues,
    this.alignParams = true,
    this.alignUnits = true,
    this.asyncAlign = true,
    this.alignCurrentValues = true,
    this.fetchListValues = true,
  });
}
