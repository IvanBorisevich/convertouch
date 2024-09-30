import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class UnitDetailsUtils {
  const UnitDetailsUtils._();

  static UnitModel getPrimaryBaseUnit({
    required List<UnitModel> baseUnits,
    required int draftUnitId,
  }) {
    return baseUnits
            .where((baseUnit) => baseUnit.id != draftUnitId)
            .firstOrNull ??
        baseUnits.firstOrNull ??
        UnitModel.none;
  }

  static UnitModel getSecondaryBaseUnit({
    required List<UnitModel> baseUnits,
    required int primaryBaseUnitId,
  }) {
    return baseUnits
            .where((baseUnit) => baseUnit.id != primaryBaseUnitId)
            .firstOrNull ??
        UnitModel.none;
  }

  static ValueModel getArgValue({
    ValueModel unitValue = ValueModel.one,
    required UnitModel argUnit,
    required UnitModel unit,
  }) {
    return argUnit.exists
        ? UnitDetailsUtils.calcNewArgValue(
            unitValue: unitValue.num ?? 1,
            unitCoefficient: unit.coefficient,
            argUnitCoefficient: argUnit.coefficient!,
          )
        : ValueModel.none;
  }

  static double? calcUnitCoefficient({
    required ValueModel value,
    required UnitModel argUnit,
    required ValueModel argValue,
  }) {
    double valueNum = double.tryParse(value.str) ?? 1;
    double argValueNum = double.tryParse(argValue.str) ?? 1;
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
