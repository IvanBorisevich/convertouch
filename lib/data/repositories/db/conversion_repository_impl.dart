import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:convertouch/data/dao/conversion_dao.dart';
import 'package:convertouch/data/dao/conversion_param_value_dao.dart';
import 'package:convertouch/data/dao/conversion_unit_value_dao.dart';
import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:convertouch/data/entities/conversion_item_value_entity.dart';
import 'package:convertouch/data/translators/conversion_item_value_translator.dart';
import 'package:convertouch/data/translators/conversion_translator.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
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
  final sqlite.Database database;

  const ConversionRepositoryImpl({
    required this.conversionDao,
    required this.conversionUnitValueDao,
    required this.conversionParamValueDao,
    required this.unitGroupRepository,
    required this.unitRepository,
    required this.database,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel?>> get(
    int unitGroupId,
  ) async {
    try {
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

      return Right(
        ConversionTranslator.I.toModel(conversion).copyWith(
              srcUnitValue: ConversionUnitValueTranslator.I.toModel(
                ConversionUnitValueEntity(
                  conversionId: conversion.id!,
                  value: conversion.sourceValue,
                  sequenceNum: 0,
                  unitId: sourceItemUnit.id,
                ),
                unit: sourceItemUnit,
              ),
              convertedUnitValues: conversionItemEntities
                  .map(
                    (entity) => ConversionUnitValueTranslator.I.toModel(
                      entity,
                      unit: conversionItemUnitsMap[entity.unitId],
                    ),
                  )
                  .nonNulls
                  .toList(),
            ),
      );
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
        resultConversion = conversion;
      } else if (conversion.convertedUnitValues.isNotEmpty) {
        log("Inserting a new conversion");
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
      }

      return Right(resultConversion);
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when merging a conversion",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
