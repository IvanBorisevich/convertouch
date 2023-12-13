import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/units_events.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchUnitsOfGroupUseCase extends UseCase<FetchUnits, List<UnitModel>> {
  final UnitRepository unitRepository;

  const FetchUnitsOfGroupUseCase(this.unitRepository);

  @override
  Future<Either<Failure, List<UnitModel>>> execute(FetchUnits input) async {
    return await unitRepository.fetchUnits(input.unitGroup.id!);
  }
}
