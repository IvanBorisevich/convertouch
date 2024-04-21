import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/unit_details/prepare_unit_details_use_case.dart';
import 'package:either_dart/either.dart';

// TODO: refactor

class PrepareDraftUnitDetailsUseCase extends PrepareUnitDetailsUseCase {
  const PrepareDraftUnitDetailsUseCase({
    required super.unitRepository,
  });

  @override
  Future<Either<ConvertouchException, UnitDetailsModel>> execute(
    UnitDetailsModel input,
  ) async {
    try {
      UnitModel argUnit = UnitModel.none;

      if (input.argUnit.notEmpty) {
        argUnit = input.argUnit;
      } else {
        argUnit = await calculateArgUnit(input);
      }

      ValueModel argValue = input.unitGroup?.conversionType == ConversionType.static
          ? ValueModel.one : ValueModel.none;
      double? newCurrentUnitCoefficient;

      if (argUnit.coefficient != null) {
        if (input.argValue.notEmpty) {
          argValue = input.argValue;
          newCurrentUnitCoefficient = await calculateCurrentUnitCoefficient(
            currentUnitValue: input.value,
            argUnit: argUnit,
            argValue: argValue,
          );
        } else {
          if (input.unit.coefficient != null) {
            argValue = await calculateArgValue(
              currentUnitCoefficient: input.unit.coefficient!,
              currentValue: ValueModel.one,
              argUnitCoefficient: argUnit.coefficient!,
            );
            newCurrentUnitCoefficient = input.unit.coefficient!;
          }
        }
      } else if (input.unitGroup?.conversionType == ConversionType.static) {
        newCurrentUnitCoefficient = 1;
      }

      return Right(
        UnitDetailsModel.coalesce(
          input,
          unit: UnitModel.coalesce(
            input.unit,
            coefficient: newCurrentUnitCoefficient,
          ),
          value: input.value.notEmpty ? input.value : ValueModel.one,
          argUnit: argUnit,
          argValue: argValue,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when preparing draft unit details",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  Future<double> calculateCurrentUnitCoefficient({
    required ValueModel currentUnitValue,
    required UnitModel argUnit,
    required ValueModel argValue,
  }) async {
    double currentValueNum = double.tryParse(currentUnitValue.strValue) ?? 1;
    double argCoefficient = argUnit.coefficient!;
    double argValueNum = double.tryParse(argValue.strValue) ?? 1;
    return argValueNum * argCoefficient / currentValueNum;
  }
}
