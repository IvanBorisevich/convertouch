import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/unit_details_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class AddUnitUseCase extends UseCase<UnitDetailsModel, int> {
  final UnitRepository unitRepository;

  const AddUnitUseCase(this.unitRepository);

  @override
  Future<Either<ConvertouchException, int>> execute(
    UnitDetailsModel input,
  ) async {
    double newUnitValue = double.tryParse(input.unitValue ?? "") ?? 1;
    double baseUnitValue = double.tryParse(input.argumentUnitValue ?? "") ?? 1;
    double baseUnitCoefficient = input.argumentUnit?.coefficient ?? 1;
    double newUnitCoefficient =
        baseUnitValue / newUnitValue * baseUnitCoefficient;

    var result = await unitRepository.add(
      UnitModel(
        name: input.unitName,
        code: input.unitCode,
        coefficient: newUnitCoefficient,
        unitGroupId: input.unitGroup!.id!,
      ),
    );

    if (result.isLeft) {
      return Left(result.left);
    }

    int addedUnitId = result.right;

    return Right(addedUnitId);
  }
}
