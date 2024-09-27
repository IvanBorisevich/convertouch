import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/formula_utils.dart';

class UnitDetailsUtils {
  const UnitDetailsUtils._();

  static String? getConversionDesc({
    required UnitGroupModel unitGroup,
    required UnitModel unitData,
    required UnitModel argUnit,
    required UnitModel secondaryBaseUnit,
    String unitValue = "1",
    required ValueModel argValue,
    required bool isBaseConversionRule,
    required bool mandatoryParamsFilled,
    required bool showNonBaseConversionRule,
  }) {
    if (unitGroup.conversionType == ConversionType.formula) {
      return FormulaUtils.getReverseStr(
        unitGroupName: unitGroup.name,
        unitCode: unitData.code,
      );
    }

    if (isBaseConversionRule) {
      return baseUnitConversionRule;
    }

    if (mandatoryParamsFilled && showNonBaseConversionRule) {
      String argUnitCode =
          unitData.id != argUnit.id ? argUnit.code : secondaryBaseUnit.code;
      return "$unitValue ${unitData.code} = "
          "${argValue.scientificValue} $argUnitCode";
    }

    return null;
  }

  static double? calcNewUnitCoefficient({
    required ValueModel value,
    required UnitModel argUnit,
    required ValueModel argValue,
  }) {
    double valueNum = double.tryParse(value.strValue) ?? 1;
    double argValueNum = double.tryParse(argValue.strValue) ?? 1;
    double? argUnitCoefficient = argUnit.coefficient;

    return argUnitCoefficient != null
        ? argValueNum * argUnitCoefficient / valueNum
        : null;
  }

  static ValueModel calcNewArgValue({
    double unitValue = 1,
    required double? unitCoefficient,
    required double argUnitCoefficient,
  }) {
    return ValueModel.ofDouble(
      unitCoefficient != null
          ? unitCoefficient / argUnitCoefficient * unitValue
          : argUnitCoefficient,
    );
  }

  static String? calcInitialUnitCode(
    String? unitName, {
    int unitCodeMaxLength = UnitDetailsModel.unitCodeMaxLength,
  }) {
    return unitName != null && unitName.length > unitCodeMaxLength
        ? unitName.substring(0, unitCodeMaxLength)
        : unitName;
  }
}
