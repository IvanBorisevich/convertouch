import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/translators/unit_group_translator.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:either_dart/either.dart';

class UnitGroupRepositoryImpl extends UnitGroupRepository {
  final UnitGroupDao unitGroupDao;

  const UnitGroupRepositoryImpl(this.unitGroupDao);

  @override
  Future<Either<Failure, List<UnitGroupModel>>> fetchUnitGroups() async {
    try {
      final result = await unitGroupDao.fetchUnitGroups();
      return Right(
        result.map((entity) => UnitGroupTranslator.I.toModel(entity)).toList(),
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when fetching unit groups: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, int>> addUnitGroup(UnitGroupModel unitGroup) async {
    try {
      final result = await unitGroupDao
          .addUnitGroup(UnitGroupTranslator.I.fromModel(unitGroup));
      return Right(result);
    } catch (e) {
      return Left(
        DatabaseFailure("Error when adding a unit group: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, UnitGroupModel>> getUnitGroup(int unitGroupId) async {
    try {
      final result = await unitGroupDao.getUnitGroup(unitGroupId);
      return Right(UnitGroupTranslator.I.toModel(result));
    } catch (e) {
      return Left(
        DatabaseFailure("Error when searching a unit group by id: $e"),
      );
    }
  }

}
