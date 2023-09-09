import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class AddUnitGroupUseCase extends UseCase<UnitGroupModel, int> {
  final UnitGroupRepository unitGroupRepository;

  const AddUnitGroupUseCase(this.unitGroupRepository);

  @override
  Future<Either<Failure, int>> execute(UnitGroupModel input) async {
    return await unitGroupRepository.addUnitGroup(input);
  }
}