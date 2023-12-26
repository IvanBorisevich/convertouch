import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/unit_groups_events.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class AddUnitGroupUseCase extends UseCase<AddUnitGroup, int> {
  final UnitGroupRepository unitGroupRepository;

  const AddUnitGroupUseCase(this.unitGroupRepository);

  @override
  Future<Either<Failure, int>> execute(AddUnitGroup input) async {
    UnitGroupModel unitGroupToBeAdded = UnitGroupModel(
      name: input.unitGroupName,
    );

    var result = await unitGroupRepository.addUnitGroup(unitGroupToBeAdded);

    if (result.isLeft) {
      return Left(result.left);
    }

    int addedUnitGroupId = result.right;

    return Right(addedUnitGroupId);
  }
}
