import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/data/dao/refreshable_value_dao.dart';
import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/refreshable_value_translator.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_data_source_model.dart';
import 'package:convertouch/domain/repositories/network_data_repository.dart';
import 'package:convertouch/domain/utils/response_transformers/response_transformer.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class NetworkDataRepositoryImpl extends NetworkDataRepository {
  final NetworkDao networkDao;
  final UnitDao unitDao;
  final RefreshableValueDao refreshableValueDao;
  final sqlite.Database database;

  const NetworkDataRepositoryImpl({
    required this.networkDao,
    required this.unitDao,
    required this.refreshableValueDao,
    required this.database,
  });

  @override
  Future<Either<ConvertouchException, bool>> isConnectionAvailable() async {
    try {
      final Connectivity connectivity = Connectivity();
      final ConnectivityResult status = await connectivity.checkConnectivity();

      return Right(status != ConnectivityResult.none);
    } catch (e, stackTrace) {
      return Left(
        NetworkException(
          message: "Error when checking connectivity: $e",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, List<T>>> refreshForGroup<T>({
    required String unitGroupName,
    required JobDataSourceModel dataSource,
    required RefreshableDataPart refreshableDataPart,
  }) async {
    try {
      String responseStr = await networkDao.fetch(dataSource.url);

      switch (refreshableDataPart) {
        case RefreshableDataPart.coefficient:
          Map<String, double?> codeToCoefficient = ResponseTransformer
              .getInstance<UnitCoefficientsResponseTransformer>(
            dataSource.responseTransformerClassName,
          ).transform(responseStr);

          List<UnitEntity> units = await unitDao.updateUnitsCoefficients(
            database,
            unitGroupName,
            codeToCoefficient,
          );
          return Right(
            units
                .map(
                  (unit) => UnitTranslator.I.toModel(unit)!,
                )
                .toList() as List<T>,
          );
        case RefreshableDataPart.value:
          Map<String, String?> codeToValue =
              ResponseTransformer.getInstance<UnitValuesResponseTransformer>(
            dataSource.responseTransformerClassName,
          ).transform(responseStr);

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
                .map(
                  (entity) => RefreshableValueTranslator.I.toModel(entity)!,
                )
                .toList() as List<T>,
          );
      }
    } catch (e, stackTrace) {
      return Left(
        NetworkException(
          message: "Error when refreshing data from network: $e",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
