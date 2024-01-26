import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchUnitGroupsUseCase extends UseCase<String?, List<UnitGroupModel>> {
  final UnitGroupRepository unitGroupRepository;

  const FetchUnitGroupsUseCase(this.unitGroupRepository);

  @override
  Future<Either<ConvertouchException, List<UnitGroupModel>>> execute(
    String? input,
  ) async {
    if (input == null || input.isEmpty) {
      return await unitGroupRepository.getAll();
    } else {
      return await unitGroupRepository.search(input);
    }
  }
}
