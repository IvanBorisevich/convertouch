import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
import 'package:convertouch/domain/usecases/units_conversion/formulas_map.dart';
import 'package:convertouch/domain/usecases/units_conversion/model/unit_conversion_input.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class ConvertUnitValueUseCase
    extends UseCase<UnitConversionInput, UnitValueModel> {
  @override
  Future<Either<Failure, UnitValueModel>> execute(
    UnitConversionInput input,
  ) async {
    return Future(() {
      try {
        double? inputValue = input.inputUnitValue.value;
        double? inputUnitCoefficient = input.inputUnitValue.unit.coefficient;
        double? targetUnitCoefficient = input.targetUnit.coefficient;
        double? targetValue;
        if (inputUnitCoefficient != null && targetUnitCoefficient != null) {
          targetValue = inputValue != null
              ? inputValue * inputUnitCoefficient / targetUnitCoefficient
              : null;
        } else {
          String group = input.unitGroup.name;
          String srcUnit = input.inputUnitValue.unit.name;
          String tgtUnit = input.targetUnit.name;

          var srcToSi = getFormula(group, srcUnit);
          var siToTgt = getFormula(group, tgtUnit);

          double? siValue = srcToSi.applyForward(inputValue);
          targetValue = siToTgt.applyReverse(siValue);
        }
        return Right(
          UnitValueModel(
            unit: input.targetUnit,
            value: targetValue,
          ),
        );
      } catch (e) {
        return Left(
          InternalFailure("Error when converting unit value: $e"),
        );
      }
    });
  }
}
