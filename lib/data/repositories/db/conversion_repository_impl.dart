import 'package:collection/collection.dart';
import 'package:convertouch/data/dao/conversion_dao.dart';
import 'package:convertouch/data/dao/conversion_item_dao.dart';
import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:convertouch/data/entities/conversion_item_entity.dart';
import 'package:convertouch/data/translators/conversion_item_translator.dart';
import 'package:convertouch/data/translators/conversion_translator.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class ConversionRepositoryImpl extends ConversionRepository {
  final ConversionDao conversionDao;
  final ConversionItemDao conversionItemDao;
  final UnitGroupRepository unitGroupRepository;
  final UnitRepository unitRepository;
  final sqlite.Database database;

  const ConversionRepositoryImpl({
    required this.conversionDao,
    required this.conversionItemDao,
    required this.unitGroupRepository,
    required this.unitRepository,
    required this.database,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> get(
    int unitGroupId,
  ) async {
    try {
      ConversionEntity? conversion = await conversionDao.getLast(unitGroupId);

      if (conversion == null) {
        return const Right(ConversionModel.none);
      }

      UnitGroupModel unitGroup = ObjectUtils.tryGet(
        await unitGroupRepository.get(unitGroupId),
      )!;
      ConversionItemEntity? sourceItemEntity =
          await conversionItemDao.getSourceItem(conversion.id!);
      List<ConversionItemEntity> conversionItemEntities =
          await conversionItemDao.getByConversionId(conversion.id!);
      List<UnitModel> conversionItemUnits = ObjectUtils.tryGet(
        await unitRepository.getByIds(
          conversionItemEntities.map((e) => e.unitId).toList(),
        ),
      );

      return Right(
        ConversionTranslator.I.toModel(
          conversion,
          unitGroup: unitGroup,
          sourceItemEntity: sourceItemEntity,
          conversionItemEntities: conversionItemEntities,
          conversionItemUnits: conversionItemUnits,
        )!,
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
      ConversionEntity entity = ConversionTranslator.I.fromModel(conversion)!;
      ConversionModel result;

      if (conversion.hasId) {
        await conversionDao.update(entity);
        await conversionItemDao.removeByConversionId(conversion.id);
        result = conversion;
      } else {
        int id = await conversionDao.insert(entity);
        result = ConversionModel.coalesce(
          conversion,
          id: id,
        );
      }

      conversionItemDao.insertBatch(
        database,
        conversion.targetConversionItems
            .mapIndexed(
              (index, item) => ConversionItemTranslator.I.fromModel(
                item,
                sourceItemUnitId: conversion.sourceConversionItem?.unit.id,
                sequenceNum: index,
                conversionId: conversion.id,
              )!,
            )
            .toList(),
      );

      return Right(result);
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
