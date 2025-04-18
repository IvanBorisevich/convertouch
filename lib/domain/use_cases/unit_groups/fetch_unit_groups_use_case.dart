import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchUnitGroupsUseCase
    extends UseCase<InputItemsFetchModel, List<UnitGroupModel>> {
  final UnitGroupRepository unitGroupRepository;

  const FetchUnitGroupsUseCase(this.unitGroupRepository);

  @override
  Future<Either<ConvertouchException, List<UnitGroupModel>>> execute(
    InputItemsFetchModel input,
  ) async {
    return await unitGroupRepository.search(
      searchString: input.searchString,
      pageNum: input.pageNum,
      pageSize: input.pageSize,
    );
  }
}
