import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class RemoveUnitsUseCase extends UseCase<List<int>, void> {
  final UnitRepository unitRepository;

  const RemoveUnitsUseCase(this.unitRepository);

  @override
  Future<Either<Failure, void>> execute(List<int> input) async {
    return await unitRepository.removeUnits(input);
  }
}