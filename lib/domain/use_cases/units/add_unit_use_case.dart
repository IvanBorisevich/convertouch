import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_creation_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class AddUnitUseCase extends UseCase<InputUnitCreationModel, int> {
  final UnitRepository unitRepository;

  const AddUnitUseCase(this.unitRepository);

  @override
  Future<Either<Failure, int>> execute(InputUnitCreationModel input) async {
    double newUnitValue = double.tryParse(input.newUnitValue ?? "") ?? 1;
    double baseUnitValue = double.tryParse(input.baseUnitValue ?? "") ?? 1;
    double baseUnitCoefficient = input.baseUnit?.coefficient ?? 1;
    double newUnitCoefficient =
        baseUnitValue / newUnitValue * baseUnitCoefficient;

    var result = await unitRepository.add(
      UnitModel(
        name: input.newUnitName,
        abbreviation: input.newUnitAbbreviation,
        coefficient: newUnitCoefficient,
        unitGroupId: input.unitGroup.id!,
      ),
    );

    if (result.isLeft) {
      return Left(result.left);
    }

    int addedUnitId = result.right;

    return Right(addedUnitId);
  }
}
