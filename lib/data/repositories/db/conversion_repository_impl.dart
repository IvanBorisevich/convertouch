import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:convertouch/data/dao/conversion_dao.dart';
import 'package:convertouch/data/dao/conversion_param_value_dao.dart';
import 'package:convertouch/data/dao/conversion_unit_value_dao.dart';
import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:convertouch/data/entities/conversion_item_value_entity.dart';
import 'package:convertouch/data/translators/conversion_item_value_translator.dart';
import 'package:convertouch/data/translators/conversion_translator.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/conversion_param_repository.dart';
import 'package:convertouch/domain/repositories/conversion_param_set_repository.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class ConversionRepositoryImpl extends ConversionRepository {
  final ConversionDao conversionDao;
  final ConversionUnitValueDao conversionUnitValueDao;
  final ConversionParamValueDao conversionParamValueDao;
  final UnitGroupRepository unitGroupRepository;
  final UnitRepository unitRepository;
  final ConversionParamRepository conversionParamRepository;
  final ConversionParamSetRepository conversionParamSetRepository;
  final sqlite.Database database;

  const ConversionRepositoryImpl({
    required this.conversionDao,
    required this.conversionUnitValueDao,
    required this.conversionParamValueDao,
    required this.unitGroupRepository,
    required this.unitRepository,
    required this.conversionParamRepository,
    required this.conversionParamSetRepository,
    required this.database,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel?>> get(
    int unitGroupId,
  ) async {
    try {
      UnitGroupModel? unitGroup = ObjectUtils.tryGet(
        await unitGroupRepository.get(unitGroupId),
      );

      if (unitGroup == null) {
        return const Right(null);
      }

      ConversionEntity? conversion = await conversionDao.getLast(unitGroupId);

      if (conversion == null || conversion.sourceUnitId == null) {
        return const Right(null);
      }

      UnitModel? sourceItemUnit = ObjectUtils.tryGet(
        await unitRepository.get(conversion.sourceUnitId!),
      );

      if (sourceItemUnit == null) {
        return const Right(null);
      }

      List<ConversionUnitValueEntity> conversionItemEntities =
          await conversionUnitValueDao.getByConversionId(conversion.id!);
      List<UnitModel> conversionItemUnits = ObjectUtils.tryGet(
        await unitRepository.getByIds(
          conversionItemEntities.map((e) => e.unitId).toList(),
        ),
      );
      Map<int, UnitModel> conversionItemUnitsMap = {
        for (var unit in conversionItemUnits) unit.id: unit
      };

      List<ConversionUnitValueModel> convertedUnitValues =
          conversionItemEntities
              .map(
                (entity) => ConversionUnitValueTranslator.I.toModel(
                  entity,
                  unit: conversionItemUnitsMap[entity.unitId],
                ),
              )
              .nonNulls
              .toList();

      ConversionUnitValueModel srcUnitValue =
          ConversionUnitValueTranslator.I.toModel(
        ConversionUnitValueEntity(
          conversionId: conversion.id!,
          value: conversion.sourceValue,
          sequenceNum: 0,
          unitId: sourceItemUnit.id,
        ),
        unit: sourceItemUnit,
      );

      ConversionModel resultConversion =
          ConversionTranslator.I.toModel(conversion).copyWith(
                srcUnitValue: srcUnitValue,
                unitGroup: unitGroup,
                convertedUnitValues: convertedUnitValues,
                params: await _getConversionParams(
                  conversionId: conversion.id!,
                  groupId: unitGroupId,
                ),
              );

      return Right(resultConversion);
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when getting a conversion",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, void>> remove(
    List<int> unitGroupIds,
  ) async {
    try {
      await conversionDao.removeByGroupIds(unitGroupIds);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when removing conversions",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, ConversionModel>> merge(
    ConversionModel conversion,
  ) async {
    try {
      log("Saving the conversion: $conversion");

      ConversionEntity entity = ConversionTranslator.I.fromModel(conversion);
      ConversionModel resultConversion = ConversionModel.none;

      if (conversion.hasId) {
        log("Updating an existing conversion: $entity");
        await conversionDao.update(entity);
        await conversionUnitValueDao.removeByConversionId(conversion.id);
        await conversionParamValueDao.removeByConversionId(conversion.id);
        resultConversion = conversion;
      } else if (conversion.convertedUnitValues.isNotEmpty) {
        log("Inserting a new conversion: $entity");
        int id = await conversionDao.insert(entity);
        resultConversion = conversion.copyWith(
          id: id,
        );
      }

      if (conversion.convertedUnitValues.isNotEmpty) {
        log("Inserting conversion items");
        log("Source unit id = ${conversion.srcUnitValue?.unit.id}");

        await conversionUnitValueDao.insertBatch(
          database,
          conversion.convertedUnitValues
              .mapIndexed(
                (index, item) => ConversionUnitValueTranslator.I.fromModel(
                  item,
                  sequenceNum: index,
                  conversionId: resultConversion.id,
                ),
              )
              .toList(),
        );

        if (conversion.params != null) {
          log("Inserting conversion params");

          for (var paramSetValue in conversion.params!.paramSetValues) {
            await conversionParamValueDao.insertBatch(
                database,
                paramSetValue.paramValues
                    .mapIndexed(
                      (index, item) => ConversionParamValueTranslator.I.fromModel(
                    item,
                    sequenceNum: index,
                    conversionId: resultConversion.id,
                  ),
                )
                    .toList());
          }
        }
      }

      return Right(resultConversion);
    } catch (e, stackTrace) {
      log("Error when merging a conversion: $e");
      return Left(
        DatabaseException(
          message: "Error when merging a conversion",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  Future<ConversionParamSetValueBulkModel?> _getConversionParams({
    required int conversionId,
    required int groupId,
  }) async {
    List<ConversionParamValueEntity> paramValueEntities =
        await conversionParamValueDao.getByConversionId(conversionId);

    if (paramValueEntities.isEmpty) {
      return null;
    }

    var groupedParamValueEntities = paramValueEntities.groupListsBy(
      (p) => p.paramSetId,
    );

    List<ConversionParamSetModel> paramSets = ObjectUtils.tryGet(
      await conversionParamSetRepository.getByIds(
        ids: groupedParamValueEntities.keys.toList(),
      ),
    );

    Map<int, ConversionParamSetModel> paramSetsMap = {
      for (var paramSet in paramSets) paramSet.id: paramSet
    };

    List<ConversionParamSetValueModel> paramSetValues = [];

    for (var paramValueEntry in groupedParamValueEntities.entries) {
      int paramSetId = paramValueEntry.key;
      var paramValueEntities = paramValueEntry.value;

      List<int> paramUnitIds =
          paramValueEntities.map((p) => p.unitId).nonNulls.toList();

      List<UnitModel> paramUnits = ObjectUtils.tryGet(
        await unitRepository.getByIds(paramUnitIds),
      );

      Map<int, UnitModel> paramUnitsMap = {
        for (var paramUnit in paramUnits) paramUnit.id: paramUnit
      };

      List<ConversionParamModel> conversionParams = ObjectUtils.tryGet(
        await conversionParamRepository.get(paramSetId),
      );

      Map<int, ConversionParamModel> conversionParamsMap = {
        for (var param in conversionParams) param.id: param
      };

      List<ConversionParamValueModel> paramValues = paramValueEntities
          .mapIndexed(
            (index, p) => ConversionParamValueTranslator.I.toModel(
              p,
              unit: paramUnitsMap[p.unitId],
              param: conversionParamsMap[p.paramId],
            ),
          )
          .toList();

      var paramSetValueModel = ConversionParamSetValueModel(
        paramSet: paramSetsMap[paramSetId]!,
        paramValues: paramValues,
      );

      paramSetValues.add(paramSetValueModel);
    }

    int totalCount = ObjectUtils.tryGet(
      await conversionParamSetRepository.getCount(groupId),
    );

    return ConversionParamSetValueBulkModel.basic(
      paramSetValues: paramSetValues,
      selectedIndex: 0,
      totalCount: totalCount,
    );
  }
}
