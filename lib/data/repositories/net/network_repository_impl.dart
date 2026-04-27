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
import 'package:convertouch/domain/model/list_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class NetworkRepositoryImpl extends NetworkRepository {
  final NetworkHelper networkHelper;
  final NetworkDao networkDao;
  final UnitDao unitDao;
  final DynamicValueDao dynamicValueDao;
  final sqlite.Database database;
  final UnitGroupRepository unitGroupRepository;

  const NetworkRepositoryImpl({
    required this.networkHelper,
    required this.networkDao,
    required this.unitDao,
    required this.dynamicValueDao,
    required this.database,
    required this.unitGroupRepository,
  });

  @override
  Future<Either<ConvertouchException, DynamicDataModel?>> fetchData({
    required ConversionParamSetValueModel params,
  }) async {
    String? unitGroupName = await _getGroupName(params.paramSet.groupId);

    if (unitGroupName == null) {
      return const Right(null);
    }

    MainDataSourceEntity? dataSource =
        mainDataSources[unitGroupName]?[params.paramSet.name];

    if (dataSource == null) {
      return const Right(null);
    }

    final result = await _fetch(
      dataSource: dataSource,
      params: params,
    );

    if (result.isLeft) {
      return Left(result.left);
    }

    ResponseEntity? response = result.right;

    if (response == null) {
      return const Right(null);
    }

    if (response is DynamicCoefficientsResponseEntity) {
      List<UnitEntity> updatedUnits = await unitDao.updateUnitsCoefficients(
        database,
        params.paramSet.groupId,
        response.unitCodeToCoefficient,
      );

      return Right(DynamicCoefficientsTranslator.I.toModel(updatedUnits));
    }

    if (response is DynamicValueResponseEntity) {
      Map<String, String?> unitCodeToValue = response.unitCodeToValue;

      List<UnitEntity> units = await unitDao.getUnitsByCodes(
        params.paramSet.groupId,
        unitCodeToValue.keys.toList(),
      );

      List<DynamicValueEntity> entities = units
          .map(
            (unit) => DynamicValueEntity(
              unitId: unit.id!,
              value: unitCodeToValue[unit.code],
            ),
          )
          .toList();

      await dynamicValueDao.updateBatch(database, entities);
      return Right(DynamicValueTranslator.I.toModel(entities.first));
    }

    return const Right(null);
  }

  @override
  Future<Either<ConvertouchException, List<ListValueModel>>> fetchList({
    required ConvertouchListType listType,
    required ConversionParamSetValueModel params,
    required int pageSize,
    required int pageNum,
  }) async {
    ListValuesDataSourceEntity? listValuesDataSource =
        listValuesSources[listType];

    if (listValuesDataSource == null) {
      return const Right([]);
    }

    final response = ObjectUtils.tryGet(
      await _fetch(
        dataSource: listValuesDataSource,
        params: params,
        pageSize: pageSize,
        pageNum: pageNum,
      ),
    );

    if (response is DynamicListValuesResponseEntity) {
      return Right(response.listValues);
    }

    return const Right([]);
  }

  Future<Either<ConvertouchException, ResponseEntity?>> _fetch({
    required DataSourceEntity dataSource,
    required ConversionParamSetValueModel params,
    int? pageSize,
    int? pageNum,
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

      RequestBuilder requestBuilder = RequestBuilderFactory.getInstance(
        dataSource,
      );

      if (!requestBuilder.readyForFetch(params)) {
        return const Right(null);
      }

      String responseStr;

      switch (requestBuilder.method) {
        case HttpMethod.get:
        default:
          responseStr = await networkDao.fetch(
            dataSource.path,
            queryParams: requestBuilder.buildQueryParams(
              params: params,
              pageSize: pageSize,
              pageNum: pageNum,
            ),
            headers: requestBuilder.buildHeaders(
              params: params,
              pageSize: pageSize,
              pageNum: pageNum,
            ),
          );
          break;
      }

      ResponseParser parser = ResponseParserFactory.getInstance(dataSource);
      return Right(parser.parse(responseStr));
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

  Future<String?> _getGroupName(int unitGroupId) async {
    UnitGroupModel? unitGroup = ObjectUtils.tryGet(
      await unitGroupRepository.get(unitGroupId),
    );

    return unitGroup?.name;
  }
}
