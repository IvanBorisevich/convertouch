import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/items_search_events.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class SearchUnitGroupsUseCase
    extends UseCase<SearchUnitGroups, List<UnitGroupModel>> {
  final UnitGroupRepository unitGroupRepository;

  const SearchUnitGroupsUseCase(this.unitGroupRepository);

  @override
  Future<Either<Failure, List<UnitGroupModel>>> execute(
    SearchUnitGroups input,
  ) async {
    return await unitGroupRepository.searchUnitGroups(input.searchString);
  }
}
