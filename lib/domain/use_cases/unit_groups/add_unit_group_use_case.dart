import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class AddUnitGroupUseCase extends UseCase<String, int> {
  final UnitGroupRepository unitGroupRepository;

  const AddUnitGroupUseCase(this.unitGroupRepository);

  @override
  Future<Either<ConvertouchException, int>> execute(String input) async {
    final result = await unitGroupRepository.add(
      UnitGroupModel(
        name: input,
      ),
    );

    if (result.isLeft) {
      return Left(result.left);
    }

    int addedUnitGroupId = result.right;
    return Right(addedUnitGroupId);
  }
}
