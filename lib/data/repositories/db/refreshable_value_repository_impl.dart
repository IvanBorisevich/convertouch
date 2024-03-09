import 'package:convertouch/data/dao/refreshable_value_dao.dart';
import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/refreshable_value_translator.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:convertouch/domain/repositories/refreshable_value_repository.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class RefreshableValueRepositoryImpl extends RefreshableValueRepository {
  final RefreshableValueDao refreshableValueDao;
  final UnitDao unitDao;
  final sqlite.Database database;

  const RefreshableValueRepositoryImpl({
    required this.refreshableValueDao,
    required this.unitDao,
    required this.database,
  });

  @override
  Future<Either<ConvertouchException, RefreshableValueModel?>> get(
      int unitId) async {
    try {
      final result = await refreshableValueDao.get(unitId);
      return Right(RefreshableValueTranslator.I.toModel(result));
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when fetching a refreshable value by unit "
              "with id = $unitId: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, List<RefreshableValueModel>>> getList(
    List<int> unitIds,
  ) async {
    try {
      final result = await refreshableValueDao.getList(unitIds);
      return Right(
        result
            .map((entity) => RefreshableValueTranslator.I.toModel(entity)!)
            .toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when getting unit values: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, List<RefreshableValueModel>>>
      updateValuesByCodes(
    String unitGroupName,
    Map<String, String?> codeToValue,
  ) async {
    try {
      List<UnitEntity> savedUnits = await unitDao.getUnitsByCodes(
        unitGroupName,
        codeToValue.keys.toList(),
      );

      List<RefreshableValueEntity> patchEntities = savedUnits
          .map(
            (unit) => RefreshableValueEntity(
              unitId: unit.id!,
              value: codeToValue[unit.code],
            ),
          )
          .toList();

      await refreshableValueDao.updateBatch(database, patchEntities);
      return Right(
        patchEntities
            .map((entity) => RefreshableValueTranslator.I.toModel(entity)!)
            .toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when batch-updating unit values: $e",
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
