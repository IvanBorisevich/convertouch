import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

ValueModel? getBarbellOneSideMass({
  required ValueModel? value,
  required UnitModel unit,
  required ConversionParamSetValueModel params,
}) {
  num? fullWeight =
      value?.numVal != null ? value!.numVal! * unit.coefficient! : null;
  num? barWeight = params.getParamValue(ParamNames.barWeight)?.eitherNum;

  if (fullWeight == null || barWeight == null) {
    return null;
  }

  return ValueModel.any((fullWeight - barWeight) / 2);
}

ValueModel? getBarbellFullMass({
  required UnitModel unit,
  required ConversionParamSetValueModel params,
}) {
  num? oneSideWeight =
      params.getParamValue(ParamNames.oneSideWeight)?.eitherNum;
  var barWeightParam = params.getParamValue(ParamNames.barWeight);

  if (oneSideWeight == null || barWeightParam?.numVal == null) {
    return null;
  }

  num? barWeight = barWeightParam!.numVal! * barWeightParam.unit!.coefficient!;

  return ValueModel.any(barWeight + oneSideWeight * 2);
}
