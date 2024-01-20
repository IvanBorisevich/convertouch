import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/translators/unit_group_translator.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:either_dart/either.dart';

class UnitGroupRepositoryImpl extends UnitGroupRepository {
  final UnitGroupDao unitGroupDao;

  const UnitGroupRepositoryImpl(this.unitGroupDao);

  @override
  Future<Either<Failure, List<UnitGroupModel>>> getAll() async {
    try {
      final result = await unitGroupDao.getAll();
      return Right(
        result.map((entity) => UnitGroupTranslator.I.toModel(entity)!).toList(),
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when fetching unit groups: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, List<UnitGroupModel>>> search(
    String searchString,
  ) async {
    try {
      List<UnitGroupEntity> result;
      if (searchString.isNotEmpty) {
        result = await unitGroupDao.getBySearchString('%$searchString%');
      } else {
        result = [];
      }
      return Right(
        result.map((entity) => UnitGroupTranslator.I.toModel(entity)!).toList(),
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when searching unit groups: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, int>> add(UnitGroupModel unitGroup) async {
    try {
      final existingGroup = await unitGroupDao.getByName(unitGroup.name);
      if (existingGroup == null) {
        final result = await unitGroupDao
            .insert(UnitGroupTranslator.I.fromModel(unitGroup)!);
        return Right(result);
      } else {
        return const Right(-1);
      }
    } catch (e) {
      return Left(
        DatabaseFailure("Error when adding a unit group: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, UnitGroupModel?>> get(
    int unitGroupId,
  ) async {
    try {
      final result = await unitGroupDao.get(unitGroupId);
      if (result == null) {
        return Left(
          DatabaseFailure(
            "Unit group with id = $unitGroupId not found",
          ),
        );
      }
      return Right(UnitGroupTranslator.I.toModel(result)!);
    } catch (e) {
      return Left(
        DatabaseFailure(
          "Error when searching a unit group by id = $unitGroupId: $e",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> remove(List<int> unitGroupIds) async {
    try {
      await unitGroupDao.remove(unitGroupIds);
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(
          "Error when deleting unit groups by ids = $unitGroupIds: $e",
        ),
      );
    }
  }
}
