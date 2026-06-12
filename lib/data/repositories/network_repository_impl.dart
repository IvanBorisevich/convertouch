import 'package:convertouch/data/dao/dynamic_value_dao.dart';
import 'package:convertouch/data/dao/network_dao.dart';
import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/dynamic_value_entity.dart';
import 'package:convertouch/data/entities/response_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/repositories/net/request_builders/request_builder.dart';
import 'package:convertouch/data/repositories/net/request_builders/request_builder_factory.dart';
import 'package:convertouch/data/repositories/net/response_parsers/response_parser_factory.dart';
import 'package:convertouch/data/translators/dynamic_coefficients_translator.dart';
import 'package:convertouch/data/translators/dynamic_value_translator.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/network_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class NetworkRepositoryImpl extends NetworkRepository {
  final NetworkDao networkDao;
  final UnitDao unitDao;
  final DynamicValueDao dynamicValueDao;
  final sqlite.Database database;
  final UnitGroupRepository unitGroupRepository;

  const NetworkRepositoryImpl({
    required this.networkDao,
    required this.unitDao,
    required this.dynamicValueDao,
    required this.database,
    required this.unitGroupRepository,
  });

  @override
  Future<Either<ConvertouchException, DynamicCoefficientsModel>>
      fetchCoefficients({
    required ConversionParamSetValueModel params,
  }) async {
    return await _fetch<DynamicCoefficientsResponseEntity,
        DynamicCoefficientsModel>(
      params: params,
      ifNullResponse: () => DynamicCoefficientsModel.empty,
      responseHandler: (response) async {
        List<UnitEntity> updatedUnits = await unitDao.updateUnitsCoefficients(
          database,
          params.paramSet.groupId,
          response.unitCodeToCoefficient,
        );

        return DynamicCoefficientsTranslator.I.toModel(updatedUnits);
      },
    );
  }

  @override
  Future<Either<ConvertouchException, DynamicValueModel>> fetchDynamicValue({
    required UnitModel unit,
    required ConversionParamSetValueModel params,
  }) async {
    return await _fetch<DynamicValueResponseEntity, DynamicValueModel>(
      params: params,
      ifNullResponse: () => DynamicValueModel(unitId: unit.id),
      responseHandler: (response) async {
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
        return DynamicValueTranslator.I.toModel(entities.first);
      },
    );
  }

  @override
  Future<Either<ConvertouchException, List<ValueModel>>> fetchListValues({
    required ConvertouchListType listType,
    required ConversionParamSetValueModel params,
    required int pageSize,
    required int pageNum,
  }) async {
    return await _fetch<DynamicListValuesResponseEntity, List<ValueModel>>(
      params: params,
      listType: listType,
      pageSize: pageSize,
      pageNum: pageNum,
      responseHandler: (response) async => response.listValues,
      ifNullResponse: () => const [],
    );
  }

  Future<Either<ConvertouchException, R>> _fetch<T extends ResponseEntity, R>({
    required ConversionParamSetValueModel params,
    ConvertouchListType? listType,
    int? pageSize,
    int? pageNum,
    required Future<R> Function(T) responseHandler,
    required R Function() ifNullResponse,
  }) async {
    try {
      String? groupName = await _getGroupName(params.paramSet.groupId);

      if (groupName == null) {
        return Right(ifNullResponse.call());
      }

      final requestBuilder = listType != null
          ? requestBuilders.getByListType(listType)
          : requestBuilders.getByGroupAndParamSet(
              groupName,
              params.paramSet.name,
            );

      final responseParser = listType != null
          ? responseParsers.getByListType(listType)
          : responseParsers.getByGroupAndParamSet(
              groupName,
              params.paramSet.name,
            );

      if (!requestBuilder.readyForFetch(params)) {
        return Right(ifNullResponse.call());
      }

      String responseStr;

      switch (requestBuilder.httpMethod) {
        case HttpMethod.get:
        default:
          responseStr = await networkDao.fetch(
            requestBuilder.path,
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

      ResponseEntity response = responseParser.parse(responseStr);

      if (response is! T) {
        return Right(ifNullResponse.call());
      }

      return Right(await responseHandler(response));
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
