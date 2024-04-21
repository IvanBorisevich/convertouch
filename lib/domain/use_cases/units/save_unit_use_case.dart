import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class SaveUnitUseCase extends UseCase<UnitModel, UnitModel> {
  final UnitRepository unitRepository;

  const SaveUnitUseCase(this.unitRepository);

  @override
  Future<Either<ConvertouchException, UnitModel>> execute(
    UnitModel input,
  ) async {
    if (input.id == null) {
      return await unitRepository.add(input);
    }
    return await unitRepository.update(input);
  }
}
