import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/model/exception_model.dart';
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
  Future<Either<ConvertouchException, List<UnitModel>>> getByGroupId(
      int unitGroupId) async {
    try {
      final result = await unitDao.getAll(unitGroupId);
      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)!).toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when fetching units of the group with id = "
              "$unitGroupId: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> search(
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
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when searching units: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, UnitModel?>> get(int id) async {
    try {
      final result = await unitDao.getUnit(id);
      return Right(UnitTranslator.I.toModel(result)!);
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when fetching unit by id = $id: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> getByIds(
      List<int>? ids) async {
    if (ids == null || ids.isEmpty) {
      return const Right([]);
    }
    try {
      final result = await unitDao.getUnitsByIds(ids);
      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)!).toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when fetching units by ids = $ids: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, Map<int, UnitModel>>> getByCodesAsMap(
    String unitGroupName,
    List<String> codes,
  ) async {
    try {
      final result = await unitDao.getUnitsByCodes(unitGroupName, codes);
      return Right(
        {for (var v in result) v.id!: UnitTranslator.I.toModel(v)!},
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when fetching units "
              "of the group = $unitGroupName "
              "by codes = $codes: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, UnitModel>> getBaseUnit(
    int unitGroupId,
  ) async {
    try {
      var result = await unitDao.getBaseUnit(unitGroupId);
      return Right(UnitTranslator.I.toModel(result) ?? UnitModel.none);
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when retrieving default base unit "
              "of the group with id = $unitGroupId: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, UnitModel?>> add(UnitModel unit) async {
    try {
      final existingUnit = await unitDao.getByCode(unit.unitGroupId, unit.name);
      if (existingUnit == null) {
        int addedUnitId =
            await unitDao.insert(UnitTranslator.I.fromModel(unit)!);
        return Right(
          UnitModel.coalesce(
            unit,
            id: addedUnitId,
          ),
        );
      } else {
        return const Right(null);
      }
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when adding a unit: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, void>> remove(List<int> unitIds) async {
    try {
      await unitDao.remove(unitIds);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when deleting units by ids = $unitIds: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, UnitModel>> update(UnitModel unit) async {
    try {
      await unitDao.update(UnitTranslator.I.fromModel(unit)!);
      return Right(unit);
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when updating the unit with id = ${unit.id}: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
