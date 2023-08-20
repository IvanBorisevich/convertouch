import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/domain/entities/failure_entity.dart';
import 'package:convertouch/domain/entities/unit_group_entity.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:dartz/dartz.dart';

class UnitGroupRepositoryImpl extends UnitGroupRepository {
  final UnitGroupDao unitGroupDao;

  const UnitGroupRepositoryImpl(this.unitGroupDao);

  @override
  Future<Either<List<UnitGroupEntity>, FailureEntity>> fetchUnitGroups() async {
    try {
      final result = await unitGroupDao.fetchUnitGroups();
      return Left(
        result.map((model) => model.toEntity()).toList(),
      );
    } on Exception {
      return const Right(
        DatabaseFailureEntity("Error when fetching unit groups"),
      );
    }
  }
}
