import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_value_model.dart';
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
        double inputValue = double.parse(input.inputUnitValue.value);
        double inputUnitCoefficient = input.inputUnitValue.unit.coefficient;
        double targetUnitCoefficient = input.targetUnit.coefficient;
        double targetValue =
            inputValue * inputUnitCoefficient / targetUnitCoefficient;
        return Right(
          UnitValueModel(
            unit: input.targetUnit,
            value: targetValue.toString(),
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
