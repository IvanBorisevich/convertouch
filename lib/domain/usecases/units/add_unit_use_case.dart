import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class AddUnitUseCase extends UseCase<UnitModel, int> {
  final UnitRepository unitRepository;

  const AddUnitUseCase(this.unitRepository);

  @override
  Future<Either<Failure, int>> execute(UnitModel input) async {
    return await unitRepository.addUnit(input);
  }
}
