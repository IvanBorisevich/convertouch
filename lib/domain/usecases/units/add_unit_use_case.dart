import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/units_events.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class AddUnitUseCase extends UseCase<AddUnit, bool> {
  final UnitRepository unitRepository;

  const AddUnitUseCase(this.unitRepository);

  @override
  Future<Either<Failure, bool>> execute({
    required AddUnit input,
  }) async {
    double newUnitValue = double.tryParse(input.newUnitValue ?? "") ?? 1;
    double baseUnitValue = double.tryParse(input.baseUnitValue ?? "") ?? 1;
    double baseUnitCoefficient = input.baseUnit?.coefficient ?? 1;
    double newUnitCoefficient =
        baseUnitValue / newUnitValue * baseUnitCoefficient;

    var result = await unitRepository.addUnit(
      UnitModel(
        name: input.newUnit.name,
        coefficient: newUnitCoefficient,
        abbreviation: input.newUnit.abbreviation,
        unitGroupId: input.newUnit.unitGroupId,
      ),
    );

    if (result.isLeft) {
      return Left(result.left);
    }

    int addedUnitId = result.right;
    bool unitCreated = addedUnitId != -1;

    return Right(unitCreated);
  }
}
