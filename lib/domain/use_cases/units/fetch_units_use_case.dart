import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchUnitsUseCase
    extends UseCase<InputItemsFetchModel<UnitsFetchParams>, List<UnitModel>> {
  final UnitRepository unitRepository;

  const FetchUnitsUseCase(this.unitRepository);

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> execute(
    InputItemsFetchModel<UnitsFetchParams> input,
  ) async {
    UnitsFetchParams? params = input.params;

    if (params == null) {
      return const Right([]);
    }

    if (params.parentItemType == ItemType.unitGroup) {
      return await unitRepository.searchWithGroupId(
        unitGroupId: params.parentItemId,
        searchString: input.searchString,
        pageNum: input.pageNum,
        pageSize: input.pageSize,
      );
    } else if (params.parentItemType == ItemType.conversionParam) {
      return await unitRepository.searchWithParamId(
        paramId: params.parentItemId,
        searchString: input.searchString,
        pageNum: input.pageNum,
        pageSize: input.pageSize,
      );
    }

    return const Right([]);
  }
}
