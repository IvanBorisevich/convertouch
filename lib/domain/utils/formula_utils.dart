import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/formula.dart';
import 'package:convertouch/domain/utils/formulas/clothing_size.dart';
import 'package:convertouch/domain/utils/formulas/temperature.dart';

class FormulaUtils {
  const FormulaUtils._();

  static ConvertouchFormula getFormula({
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

  static String? getForwardStr({
    required String unitGroupName,
    required String unitCode,
  }) {
    return getFormula(
      unitGroupName: unitGroupName,
      unitCode: unitCode,
    ).forwardStr;
  }

  static String? getReverseStr({
    required String unitGroupName,
    required String unitCode,
  }) {
    return getFormula(
      unitGroupName: unitGroupName,
      unitCode: unitCode,
    ).reverseStr;
  }
}

final FormulasMap formulasMap = {
  GroupNames.temperature: temperatureFormulas,
  GroupNames.clothingSize: clothingSizeFormulas,
};
