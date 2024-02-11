import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class SaveUnitUseCase extends UseCase<UnitModel, int> {
  final UnitRepository unitRepository;

  const SaveUnitUseCase(this.unitRepository);

  @override
  Future<Either<ConvertouchException, int>> execute(
    UnitModel input,
  ) async {
    if (input.id == null) {
      return await unitRepository.add(input);
    }
    await unitRepository.update(input);
    return Right(input.id!);
  }
}
