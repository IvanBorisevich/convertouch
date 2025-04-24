import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/conversion_rule.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/formulas/clothing_size.dart';
import 'package:convertouch/domain/utils/formulas/temperature.dart';

class ConversionRuleUtils {
  const ConversionRuleUtils._();

  static ConversionRule getFormulaRule({
    required String unitGroupName,
    required String unitCode,
  }) {
    var formula = formulasMap[unitGroupName]?[unitCode];
    if (formula == null) {
      throw Exception(
        "Formula not found for unit group $unitGroupName "
        "and unit code = $unitCode",
      );
    }
    return formula;
  }

  static ValueModel? calculate(
    ValueModel? x, {
    required ConversionRule srcUnitRule,
    required ConversionRule tgtUnitRule,
    ConversionParamSetValueModel? params,
  }) {
    if (x == null) {
      return null;
    }

    ValueModel? baseValue;
    if (srcUnitRule.toBase != null) {
      baseValue = srcUnitRule.toBase!.call(x, params: params);
    } else {
      baseValue = null;
    }

    if (baseValue == null) {
      return null;
    }

    ValueModel? y;
    if (tgtUnitRule.fromBase != null) {
      y = tgtUnitRule.fromBase!.call(baseValue, params: params);
    } else {
      y = null;
    }

    return y;
  }
}

final FormulasMap formulasMap = {
  GroupNames.temperature: temperatureFormulas,
  GroupNames.clothingSize: clothingSizeFormulas,
};
