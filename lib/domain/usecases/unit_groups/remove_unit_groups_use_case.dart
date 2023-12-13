import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/unit_groups_events.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class RemoveUnitGroupsUseCase extends UseCase<RemoveUnitGroups, void> {
  final UnitGroupRepository unitGroupRepository;

  const RemoveUnitGroupsUseCase(this.unitGroupRepository);

  @override
  Future<Either<Failure, void>> execute(RemoveUnitGroups input) async {
    return await unitGroupRepository.removeUnitGroups(input.ids);
  }
}