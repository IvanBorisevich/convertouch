import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/units/model/unit_adding_input.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class AddUnitUseCase extends UseCase<UnitAddingInput, int> {
  final UnitRepository unitRepository;

  const AddUnitUseCase(this.unitRepository);

  @override
  Future<Either<Failure, int>> execute(UnitAddingInput input) async {
    double newUnitValue = input.newUnitValue;
    double equivalentUnitValue = input.equivalentUnitValue ?? 1;
    double equivalentUnitCoefficient = input.equivalentUnit?.coefficient ?? 1;
    double newUnitCoefficient =
        equivalentUnitValue / newUnitValue * equivalentUnitCoefficient;

    return await unitRepository.addUnit(
      UnitModel(
        name: input.newUnit.name,
        coefficient: newUnitCoefficient,
        abbreviation: input.newUnit.abbreviation,
        unitGroupId: input.newUnit.unitGroupId,
      ),
    );
  }
}
