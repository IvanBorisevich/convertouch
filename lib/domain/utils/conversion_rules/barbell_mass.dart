import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';

ValueModel? getBarbellOneSideMassByFullMass({
  required ValueModel? srcValue,
  required UnitModel srcUnit,
  required ConversionParamSetValueModel params,
}) {
  num? fullWeight = srcValue?.numVal != null
      ? srcValue!.numVal! * srcUnit.coefficient!
      : null;

  var barWeightParam = params.getParamValue(ParamNames.barWeight);
  var oneSideMassParam = params.getParamValue(ParamNames.oneSideWeight);

  num? barWeight = barWeightParam?.eitherNum;

  if (fullWeight == null ||
      barWeight == null ||
      barWeightParam?.unit?.coefficient == null ||
      oneSideMassParam?.unit?.coefficient == null) {
    return null;
  }

  num? result = (fullWeight - barWeight * barWeightParam!.unit!.coefficient!) /
      2 /
      oneSideMassParam!.unit!.coefficient!;

  return ValueModel.any(result);
}

ValueModel? getBarbellFullMass({
  required UnitModel srcUnit,
  required ParamValueFunc paramValueFunc,
  required ConversionParamSetValueModel params,
}) {
  var oneSideMass = params.getParamValue(ParamNames.oneSideWeight);
  var barMass = params.getParamValue(ParamNames.barWeight);

  if (oneSideMass == null || barMass == null || srcUnit.coefficient == null) {
    return null;
  }

  ValueModel? oneSideMassVal = paramValueFunc.call(oneSideMass);
  ValueModel? barMassVal = paramValueFunc.call(barMass);

  num? oneSideMassNum = oneSideMassVal != null
      ? oneSideMassVal.numVal! * oneSideMass.unit!.coefficient!
      : null;
  num? barMassNum = barMassVal != null
      ? barMassVal.numVal! * barMass.unit!.coefficient!
      : null;

  if (oneSideMassNum == null || barMassNum == null) {
    return null;
  }

  num? result = (barMassNum + oneSideMassNum * 2) / srcUnit.coefficient!;
  return ValueModel.any(result);
}
