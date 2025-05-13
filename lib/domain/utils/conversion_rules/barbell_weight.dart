import 'package:collection/collection.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

ValueModel? getOneSideWeight({
  required ConversionUnitValueModel value,
  required List<ConversionParamValueModel> paramValues,
}) {
  num? fullWeight = value.numVal;
  num? barWeight = paramValues
      .firstWhereOrNull((p) => p.param.name == ParamNames.barWeight)
      ?.numVal;

  if (fullWeight == null || barWeight == null) {
    return null;
  }

  return ValueModel.any((fullWeight - barWeight) / 2);
}
