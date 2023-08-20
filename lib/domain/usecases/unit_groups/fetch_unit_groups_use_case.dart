import 'package:convertouch/domain/entities/failure_entity.dart';
import 'package:convertouch/domain/entities/unit_group_entity.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:dartz/dartz.dart';

class FetchUnitGroupsUseCase extends UseCase<List<UnitGroupEntity>, void> {
  final UnitGroupRepository unitGroupRepository;

  const FetchUnitGroupsUseCase(this.unitGroupRepository);

  @override
  Future<Either<List<UnitGroupEntity>, FailureEntity>> execute({void input}) {
    return unitGroupRepository.fetchUnitGroups();
  }
}
