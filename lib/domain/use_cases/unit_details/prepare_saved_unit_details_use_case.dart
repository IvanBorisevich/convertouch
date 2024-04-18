import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/unit_details/prepare_unit_details_use_case.dart';
import 'package:either_dart/either.dart';


// TODO: refactor

class PrepareSavedUnitDetailsUseCase extends PrepareUnitDetailsUseCase {
  const PrepareSavedUnitDetailsUseCase({
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

      ValueModel argValue = ValueModel.none;

      if (input.unit.coefficient != null && argUnit.coefficient != null) {
        if (input.argValue.notEmpty) {
          argValue = input.argValue;
        } else {
          argValue = await calculateArgValue(
            currentUnitCoefficient: input.unit.coefficient!,
            currentValue: ValueModel.one,
            argUnitCoefficient: argUnit.coefficient!,
          );
        }
      }

      return Right(
        UnitDetailsModel.coalesce(
          input,
          unit: UnitModel.coalesce(
            input.unit,
            code: input.unit.code,
          ),
          value: ValueModel.one,
          argUnit: argUnit,
          argValue: argValue,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when preparing saved unit details: $e",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
