import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class UnitRepositoryImpl extends UnitRepository {
  final UnitDao unitDao;
  final UnitGroupDao unitGroupDao;
  final sqlite.Database database;

  const UnitRepositoryImpl({
    required this.unitDao,
    required this.unitGroupDao,
    required this.database,
  });

  @override
  Future<Either<Failure, List<UnitModel>>> getByGroupId(int unitGroupId) async {
    try {
      final result = await unitDao.getAll(unitGroupId);
      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)!).toList(),
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when fetching units of the group with id = "
            "$unitGroupId: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, List<UnitModel>>> search(
      int unitGroupId, String searchString) async {
    try {
      List<UnitEntity> result;
      if (searchString.isNotEmpty) {
        result = await unitDao.getBySearchString(
          unitGroupId,
          '%$searchString%',
        );
      } else {
        result = [];
      }
      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)!).toList(),
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when searching units: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, UnitModel?>> get(int id) async {
    try {
      final result = await unitDao.getUnit(id);
      return Right(UnitTranslator.I.toModel(result)!);
    } catch (e) {
      return Left(
        DatabaseFailure("Error when fetching unit by id = $id: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, List<UnitModel>>> getByIds(List<int>? ids) async {
    if (ids == null || ids.isEmpty) {
      return const Right([]);
    }
    try {
      final result = await unitDao.getUnitsByIds(ids);
      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)!).toList(),
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when fetching units by ids = $ids: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, Map<int, UnitModel>>> getByCodesAsMap(
    int unitGroupId,
    List<String> codes,
  ) async {
    try {
      final result = await unitDao.getUnitsByCodes(unitGroupId, codes);
      return Right(
        {for (var v in result) v.id!: UnitTranslator.I.toModel(v)!},
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when fetching units "
            "of the group with id = $unitGroupId "
            "by codes = $codes: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, UnitModel?>> getBaseUnit(int unitGroupId) async {
    try {
      var result = await unitDao.getBaseUnit(unitGroupId);
      return Right(UnitTranslator.I.toModel(result));
    } catch (e) {
      return Left(
        DatabaseFailure("Error when retrieving default base unit "
            "of the group with id = $unitGroupId: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, int>> add(UnitModel unit) async {
    try {
      final existingUnit = await unitDao.getByCode(unit.unitGroupId, unit.name);
      if (existingUnit == null) {
        final result = await unitDao.insert(UnitTranslator.I.fromModel(unit)!);
        return Right(result);
      } else {
        return const Right(-1);
      }
    } catch (e) {
      return Left(
        DatabaseFailure("Error when adding a unit: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> remove(List<int> unitIds) async {
    try {
      await unitDao.remove(unitIds);
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(
          "Error when deleting units by ids = $unitIds: $e",
        ),
      );
    }
  }
}
