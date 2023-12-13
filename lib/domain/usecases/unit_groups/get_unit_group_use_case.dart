import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class GetUnitGroupUseCase extends UseCase<int, UnitGroupModel> {
  final UnitGroupRepository unitGroupRepository;

  const GetUnitGroupUseCase(this.unitGroupRepository);

  @override
  Future<Either<Failure, UnitGroupModel>> execute(int input) async {
    return await unitGroupRepository.getUnitGroup(input);
  }
}
