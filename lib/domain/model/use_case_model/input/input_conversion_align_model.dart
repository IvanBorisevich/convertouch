import 'package:convertouch/domain/model/conversion_model.dart';

class InputConversionAlignModel {
  final ConversionModel conversion;
  final int? paramIdToRefreshListValues;
  final bool alignParams;
  final bool alignUnits;

  const InputConversionAlignModel({
    required this.conversion,
    this.paramIdToRefreshListValues,
    this.alignParams = true,
    this.alignUnits = true,
  });
}
