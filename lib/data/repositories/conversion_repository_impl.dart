import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/repositories/preferences_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:either_dart/either.dart';

class ConversionRepositoryImpl extends ConversionRepository {
  final PreferencesRepository preferencesRepository;
  final UnitGroupRepository unitGroupRepository;
  final UnitRepository unitRepository;

  const ConversionRepositoryImpl({
    required this.preferencesRepository,
    required this.unitGroupRepository,
    required this.unitRepository,
  });

  @override
  Future<Either<Failure, InputConversionModel?>> getLastConversion() async {
    try {
      return Right(
        InputConversionModel(
          unitGroup: await _getUnitGroup(),
          sourceConversionItem: await _getSourceConversionItem(),
          targetUnits: await _getTargetUnits(),
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure(
          "Error when fetching conversion properties: $e",
        ),
      );
    }
  }

  Future<UnitGroupModel?> _getUnitGroup() async {
    final conversionUnitGroupResult =
        await preferencesRepository.get<int>(conversionUnitGroupIdKey);

    if (conversionUnitGroupResult.isLeft) {
      throw conversionUnitGroupResult.left;
    }

    final unitGroupResult =
        await unitGroupRepository.get(conversionUnitGroupResult.right);

    if (unitGroupResult.isLeft) {
      throw unitGroupResult.left;
    }

    return unitGroupResult.right;
  }

  Future<ConversionItemModel?> _getSourceConversionItem() async {
    final sourceUnitResult =
        await preferencesRepository.get<int>(sourceUnitIdKey);

    if (sourceUnitResult.isLeft) {
      throw sourceUnitResult.left;
    }

    var unitResult = await unitRepository.get(sourceUnitResult.right);

    if (unitResult.isLeft) {
      throw unitResult.left;
    }

    if (unitResult.right == null) {
      return null;
    }

    final sourceValueResult =
        await preferencesRepository.get<String>(sourceValueKey);

    if (sourceValueResult.isLeft) {
      throw sourceValueResult.left;
    }

    return ConversionItemModel.fromStrValue(
      unit: unitResult.right!,
      strValue: sourceValueResult.right ?? "",
    );
  }

  Future<List<UnitModel>?> _getTargetUnits() async {
    final targetUnitIdsResult =
        await preferencesRepository.getList<int>(targetUnitIdsKey);

    if (targetUnitIdsResult.isLeft) {
      throw targetUnitIdsResult.left;
    }

    var targetUnitsResult =
        await unitRepository.getByIds(targetUnitIdsResult.right);

    if (targetUnitsResult.isLeft) {
      throw targetUnitsResult.left;
    }

    return targetUnitsResult.right;
  }

  @override
  Future<Either<Failure, void>> saveConversion(
    InputConversionModel conversion,
  ) async {
    try {
      if (conversion.unitGroup != null) {
        await preferencesRepository.save<int>(
          conversionUnitGroupIdKey,
          conversion.unitGroup!.id!,
        );
      } else {
        return const Right(null);
      }

      if (conversion.sourceConversionItem != null) {
        await preferencesRepository.save<int>(
          sourceUnitIdKey,
          conversion.sourceConversionItem!.unit.id!,
        );
        await preferencesRepository.save<String>(
          sourceValueKey,
          conversion.sourceConversionItem!.value.strValue,
        );
      }

      if (conversion.targetUnits != null) {
        await preferencesRepository.saveList<int>(
          targetUnitIdsKey,
          conversion.targetUnits!.map((unit) => unit.id!).toList(),
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(
        InternalFailure("Error when saving conversion properties: $e"),
      );
    }
  }
}
