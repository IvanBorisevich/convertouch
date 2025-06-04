import 'package:convertouch/data/dao/conversion_param_unit_dao.dart';
import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:either_dart/either.dart';

class UnitRepositoryImpl extends UnitRepository {
  final UnitDao unitDao;
  final ConversionParamUnitDao conversionParamUnitDao;

  const UnitRepositoryImpl({
    required this.unitDao,
    required this.conversionParamUnitDao,
  });

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> searchWithGroupId({
    required int unitGroupId,
    String? searchString,
    required int pageNum,
    required int pageSize,
  }) async {
    try {
      String searchPattern = searchString != null && searchString.isNotEmpty
          ? '%$searchString%'
          : '%';

      List<UnitEntity> result = await unitDao.searchWithGroupId(
        unitGroupId: unitGroupId,
        searchString: searchPattern,
        pageSize: pageSize,
        offset: pageNum * pageSize,
      );
      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)).toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when searching units of the group id = $unitGroupId",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, List<UnitModel>>> searchWithParamId({
    required int paramId,
    String? searchString,
    required int pageNum,
    required int pageSize,
  }) async {
    try {
      int? possibleUnitsExistenceFlag =
          await conversionParamUnitDao.hasPossibleUnits(paramId);

      bool hasPossibleUnits =
          possibleUnitsExistenceFlag != null && possibleUnitsExistenceFlag > 0;

      String searchPattern = searchString != null && searchString.isNotEmpty
          ? '%$searchString%'
          : '%';

      List<UnitEntity> result;
      if (hasPossibleUnits) {
        result = await unitDao.searchWithParamIdAndPossibleUnits(
          paramId: paramId,
          searchString: searchPattern,
          pageSize: pageSize,
          offset: pageNum * pageSize,
        );
      } else {
        result = await unitDao.searchWithParamId(
          paramId: paramId,
          searchString: searchPattern,
          pageSize: pageSize,
          offset: pageNum * pageSize,
        );
      }

      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)).toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when searching units of the param id = $paramId",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, UnitModel?>> get(int id) async {
    try {
      final unit = await unitDao.getUnit(id);
      return Right(unit != null ? UnitTranslator.I.toModel(unit) : null);
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
    List<int>? ids,
  ) async {
    if (ids == null || ids.isEmpty) {
      return const Right([]);
    }
    try {
      final result = await unitDao.getUnitsByIds(ids);
      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)).toList(),
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
        {for (var v in result) v.id!: UnitTranslator.I.toModel(v)},
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
        result.map((entity) => UnitTranslator.I.toModel(entity)).toList(),
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
            await unitDao.insert(UnitTranslator.I.fromModel(unit));
        return Right(
          unit.copyWith(
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
      await unitDao.update(UnitTranslator.I.fromModel(unit));
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
