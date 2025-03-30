import 'package:convertouch/data/dao/dynamic_value_dao.dart';
import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/translators/dynamic_value_translator.dart';
import 'package:convertouch/domain/model/dynamic_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class DynamicValueRepositoryImpl extends DynamicValueRepository {
  final DynamicValueDao dynamicValueDao;
  final UnitDao unitDao;
  final sqlite.Database database;

  const DynamicValueRepositoryImpl({
    required this.dynamicValueDao,
    required this.unitDao,
    required this.database,
  });

  @override
  Future<Either<ConvertouchException, DynamicValueModel>> get(
    int unitId,
  ) async {
    try {
      final result = await dynamicValueDao.get(unitId);
      return Right(
        result != null
            ? DynamicValueTranslator.I.toModel(result)
            : DynamicValueModel(unitId: unitId),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when fetching a dynamic value by unit with id",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, List<DynamicValueModel>>> getList(
    List<int> unitIds,
  ) async {
    try {
      final result = await dynamicValueDao.getList(unitIds);
      return Right(
        result
            .map((entity) => DynamicValueTranslator.I.toModel(entity))
            .toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when getting unit values",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
