import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/unit_groups_events.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchUnitGroupsUseCase
    extends UseCase<FetchUnitGroups, List<UnitGroupModel>> {
  final UnitGroupRepository unitGroupRepository;

  const FetchUnitGroupsUseCase(this.unitGroupRepository);

  @override
  Future<Either<Failure, List<UnitGroupModel>>> execute({
    FetchUnitGroups input = const FetchUnitGroups(),
  }) async {
    return await unitGroupRepository.fetchUnitGroups(
      searchString: input.searchString,
    );
  }
}
