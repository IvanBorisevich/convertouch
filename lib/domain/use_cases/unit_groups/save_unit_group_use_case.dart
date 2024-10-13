import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class SaveUnitGroupUseCase extends UseCase<UnitGroupModel, UnitGroupModel> {
  final UnitGroupRepository unitGroupRepository;

  const SaveUnitGroupUseCase(this.unitGroupRepository);

  @override
  Future<Either<ConvertouchException, UnitGroupModel>> execute(
    UnitGroupModel input,
  ) async {
    if (!input.hasId) {
      return await unitGroupRepository.add(input);
    }
    return await unitGroupRepository.update(input);
  }
}
