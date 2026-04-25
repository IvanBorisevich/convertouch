import 'package:convertouch/data/const/data_sources.dart';
import 'package:convertouch/data/dao/dynamic_value_dao.dart';
import 'package:convertouch/data/dao/net/network_helper/network_helper.dart';
import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/data_source_entity.dart';
import 'package:convertouch/data/entities/dynamic_value_entity.dart';
import 'package:convertouch/data/entities/response_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/repositories/net/request_builders/request_builder.dart';
import 'package:convertouch/data/repositories/net/request_builders/request_builder_factory.dart';
import 'package:convertouch/data/repositories/net/response_parsers/response_parser.dart';
import 'package:convertouch/data/repositories/net/response_parsers/response_parser_factory.dart';
import 'package:convertouch/data/translators/dynamic_coefficients_translator.dart';
import 'package:convertouch/data/translators/dynamic_value_translator.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class NetworkRepositoryImpl extends NetworkRepository {
  final NetworkHelper networkHelper;
  final NetworkDao networkDao;
  final UnitDao unitDao;
  final DynamicValueDao dynamicValueDao;
  final sqlite.Database database;

  const NetworkRepositoryImpl({
    required this.networkHelper,
    required this.networkDao,
    required this.unitDao,
    required this.dynamicValueDao,
    required this.database,
  });

  @override
  Future<Either<ConvertouchException, DynamicDataModel?>> getRefreshedData({
    required String unitGroupName,
    required ConversionParamSetValueModel params,
  }) async {
    try {
      bool isConnected = await networkHelper.isConnected();

      if (!isConnected) {
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

      DataSourceEntity? dataSource =
          convertouchDataSources[unitGroupName]?[params.paramSet.name];

      if (dataSource == null) {
        return const Right(null);
      }

      RequestBuilder requestBuilder = RequestBuilderFactory.getInstance(
        dataSource.dynamicDataType,
      );

      String responseStr;

      switch (requestBuilder.method) {
        case HttpMethod.get:
        default:
          responseStr = await networkDao.fetch(
            dataSource.path,
            queryParams: requestBuilder.buildQueryParams(params),
            headers: requestBuilder.buildHeaders(params),
          );
          break;
      }

      ResponseParser parser = ResponseParserFactory.getInstance(
        dataSource.dynamicDataType,
      );

      ResponseEntity response = parser.parse(responseStr);

      if (response is DynamicCoefficientsResponseEntity) {
        List<UnitEntity> updatedUnits = await unitDao.updateUnitsCoefficients(
          database,
          unitGroupName,
          response.unitCodeToCoefficient,
        );

        return Right(DynamicCoefficientsTranslator.I.toModel(updatedUnits));
      } else if (response is DynamicValueResponseEntity) {
        List<UnitEntity> units = await unitDao.getUnitsByCodes(
          unitGroupName,
          response.unitCodeToValue.keys.toList(),
        );
        List<DynamicValueEntity> entities = units
            .map(
              (unit) => DynamicValueEntity(
                unitId: unit.id!,
                value: response.unitCodeToValue[unit.code],
              ),
            )
            .toList();

        await dynamicValueDao.updateBatch(database, entities);
        return Right(DynamicValueTranslator.I.toModel(entities.first));
      }

      return const Right(null);
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
}
