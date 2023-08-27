import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class GetBaseUnitUseCase extends UseCase<int, UnitModel> {
  final UnitRepository unitRepository;

  const GetBaseUnitUseCase(this.unitRepository);

  @override
  Future<Either<Failure, UnitModel>> execute(int input) async {
    return await unitRepository.getBaseUnit(input);
  }
}
