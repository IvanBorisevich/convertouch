import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_fetch_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchUnitsUseCase extends UseCase<InputUnitFetchModel, List<UnitModel>> {
  final UnitRepository unitRepository;

  const FetchUnitsUseCase(this.unitRepository);

  @override
  Future<Either<Failure, List<UnitModel>>> execute(
    InputUnitFetchModel input,
  ) async {
    if (input.searchString == null || input.searchString!.isEmpty) {
      return await unitRepository.fetchUnits(input.unitGroupId);
    } else {
      return await unitRepository.searchUnits(
        input.unitGroupId,
        input.searchString!,
      );
    }
  }
}
