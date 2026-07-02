import 'package:convertouch/data/dao/dynamic_value_dao.dart';
import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/translators/dynamic_value_translator.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class DynamicValueRepositoryImpl extends DynamicValueRepository {
  final NetworkRepository networkRepository;
  final DynamicValueDao dynamicValueDao;
  final UnitDao unitDao;
  final sqlite.Database database;

  const DynamicValueRepositoryImpl({
    required this.networkRepository,
    required this.dynamicValueDao,
    required this.unitDao,
    required this.database,
  });

  @override
  Future<Either<ConvertouchException, DynamicValueModel?>> get({
    required UnitModel unit,
    required String conversionGroupName,
    ConversionParamSetValueModel? params,
  }) async {
    try {
      var result = await dynamicValueDao.get(unit.id);

      if (result != null) {
        return Right(DynamicValueTranslator.I.toModel(result));
      }

      if (params != null) {
        return await networkRepository.fetchDynamicValue(
          unit: unit,
          conversionGroupName: conversionGroupName,
          params: params,
        );
      }

      return const Right(null);
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
}
