import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchUnitsUseCase extends UseCase<InputItemsFetchModel, List<UnitModel>> {
  final UnitRepository unitRepository;

  const FetchUnitsUseCase(this.unitRepository);

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> execute(
    InputItemsFetchModel input,
  ) async {
    if (input.searchString == null || input.searchString!.isEmpty) {
      return await unitRepository.getPageByGroupId(
        unitGroupId: input.parentItemId,
        pageNum: input.pageNum,
        pageSize: input.pageSize,
      );
    } else {
      return await unitRepository.search(
        unitGroupId: input.parentItemId,
        searchString: input.searchString!,
        pageNum: input.pageNum,
        pageSize: input.pageSize,
      );
    }
  }
}
