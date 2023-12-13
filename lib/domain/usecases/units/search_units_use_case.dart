import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/items_search_events.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class SearchUnitsUseCase extends UseCase<SearchUnits, List<UnitModel>?> {
  final UnitRepository unitRepository;

  const SearchUnitsUseCase(this.unitRepository);

  @override
  Future<Either<Failure, List<UnitModel>?>> execute(
    SearchUnits input,
  ) async {
    if (input.searchString.isEmpty) {
      return const Right(null);
    }
    return await unitRepository.searchUnits(
      input.unitGroupId,
      input.searchString,
    );
  }
}
