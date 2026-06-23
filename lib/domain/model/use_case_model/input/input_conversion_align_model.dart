import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';

class InputConversionAlignModel {
  final ConversionModel conversion;
  final ListValuesAsyncFetchMode listValuesAsyncFetchMode;
  final void Function(ConversionParamValueModel)? onParamValueUpdated;

  const InputConversionAlignModel({
    required this.conversion,
    this.listValuesAsyncFetchMode = ListValuesAsyncFetchMode.viaApiOnly,
    this.onParamValueUpdated,
  });
}
