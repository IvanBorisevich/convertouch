import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:either_dart/either.dart';

class UnitRepositoryImpl extends UnitRepository {
  final UnitDao unitDao;

  const UnitRepositoryImpl({
    required this.unitDao,
  });

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> getPageByGroupId({
    required int unitGroupId,
    required int pageNum,
    required int pageSize,
  }) async {
    try {
      final result = await unitDao.getAll(
        unitGroupId: unitGroupId,
        pageSize: pageSize,
        offset: pageNum * pageSize,
      );

      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)!).toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when fetching units of the group with id = "
              "$unitGroupId",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> search({
    required int unitGroupId,
    required String searchString,
    int pageNum = 0,
    required int pageSize,
  }) async {
    try {
      List<UnitEntity> result;
      if (searchString.isNotEmpty) {
        result = await unitDao.getBySearchString(
          unitGroupId: unitGroupId,
          searchString: '%$searchString%',
          pageSize: pageSize,
          offset: pageNum * pageSize,
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
          message: "Error when searching units",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
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
          message: "Error when fetching unit by id",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
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
          message: "Error when fetching units by ids",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
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
              "by codes = $codes",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> getBaseUnits(
    int unitGroupId,
  ) async {
    try {
      var result = await unitDao.getBaseUnits(unitGroupId);
      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)!).toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when retrieving default base unit "
              "of the group with id = $unitGroupId",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, UnitModel>> add(UnitModel unit) async {
    try {
      final existingUnit = await unitDao.getByCode(unit.unitGroupId, unit.code);
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
        String unitCode = existingUnit.code;
        String unitName = existingUnit.name;

        return Left(
          DatabaseException(
            message: "Unit with the code '$unitCode' ($unitName) "
                "already exists",
            stackTrace: null,
            dateTime: DateTime.now(),
            severity: ExceptionSeverity.info,
          ),
        );
      }
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when adding a unit: code [${unit.code}], "
              "name [${unit.name}]",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
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
          message: "Error when deleting units by ids = $unitIds",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
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
          message: "Error when updating the unit with id = ${unit.id}",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
