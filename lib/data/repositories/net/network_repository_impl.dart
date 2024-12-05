import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:convertouch/data/dao/dynamic_value_dao.dart';
import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/dynamic_value_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/dynamic_value_translator.dart';
import 'package:convertouch/data/translators/response_translators/response_translator.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/data_source_model.dart';
import 'package:convertouch/domain/model/dynamic_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/network_data_model.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class NetworkRepositoryImpl extends NetworkRepository {
  final NetworkDao networkDao;
  final UnitDao unitDao;
  final DynamicValueDao dynamicValueDao;
  final sqlite.Database database;

  const NetworkRepositoryImpl({
    required this.networkDao,
    required this.unitDao,
    required this.dynamicValueDao,
    required this.database,
  });

  @override
  Future<Either<ConvertouchException, NetworkDataModel>> getRefreshedData({
    required String unitGroupName,
    required DataSourceModel dataSource,
  }) async {
    try {
      final Connectivity connectivity = Connectivity();
      final ConnectivityResult status = await connectivity.checkConnectivity();

      if (status == ConnectivityResult.none) {
        return Left(
          NetworkException(
            message: "No internet connection",
            severity: ExceptionSeverity.warning,
            stackTrace: null,
            dateTime: DateTime.now(),
            handlingAction: ConvertouchSysAction.connection,
          ),
        );
      }

      Map<String, double?>? dynamicCoefficients;
      DynamicValueModel? dynamicValue;
      String responseStr = await networkDao.fetch(dataSource.url);

      if (dataSource.refreshablePart == RefreshableDataPart.coefficient) {
        dynamicCoefficients = await _getDynamicCoefficients(
          responseStr: responseStr,
          unitGroupName: unitGroupName,
          dataSource: dataSource,
        );
      }

      if (dataSource.refreshablePart == RefreshableDataPart.value) {
        dynamicValue = await _getDynamicValue(
          responseStr: responseStr,
          unitGroupName: unitGroupName,
          dataSource: dataSource,
        );
      }

      return Right(
        NetworkDataModel(
          dynamicCoefficients: dynamicCoefficients,
          dynamicValue: dynamicValue,
        ),
      );
    } on NetworkException catch (e) {
      return Left(e);
    } on Exception catch (e, stackTrace) {
      return Left(
        NetworkException(
          message: "Error when retrieving dynamic data",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
          severity: ExceptionSeverity.warning,
        ),
      );
    }
  }

  Future<Map<String, double?>?> _getDynamicCoefficients({
    required String responseStr,
    required String unitGroupName,
    required DataSourceModel dataSource,
  }) async {
    final translator = DynamicCoefficientsResponseTranslator.getInstance(
      dataSource.responseTransformerClassName,
    );

    Map<String, double?> dynamicCoefficients = translator.toEntity(responseStr);

    await unitDao.updateUnitsCoefficients(
      database,
      unitGroupName,
      dynamicCoefficients,
    );

    return dynamicCoefficients;
  }

  Future<DynamicValueModel?> _getDynamicValue({
    required String responseStr,
    required String unitGroupName,
    required DataSourceModel dataSource,
  }) async {
    final translator = DynamicValuesResponseTranslator.getInstance(
      dataSource.responseTransformerClassName,
    );

    Map<String, String?>? dynamicValuesMap = translator.toEntity(responseStr);

    if (dynamicValuesMap != null) {
      List<UnitEntity> units = await unitDao.getUnitsByCodes(
          unitGroupName, dynamicValuesMap.keys.toList());
      List<DynamicValueEntity> entities = units
          .map(
            (unit) => DynamicValueEntity(
              unitId: unit.id!,
              value: dynamicValuesMap[unit.code],
            ),
          )
          .toList();

      await dynamicValueDao.updateBatch(database, entities);
      return DynamicValueTranslator.I.toModel(entities.first);
    }

    return null;
  }
}
