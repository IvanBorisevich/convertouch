import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class RemoveUnitGroupsUseCase extends UseCase<List<int>, void> {
  final UnitGroupRepository unitGroupRepository;

  const RemoveUnitGroupsUseCase(this.unitGroupRepository);

  @override
  Future<Either<Failure, void>> execute({
    required List<int> input,
  }) async {
    return await unitGroupRepository.removeUnitGroups(input);
  }
}