import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/conversion_events.dart';
import 'package:convertouch/domain/model/output/conversion_states.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/conversion_repository.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/usecases/conversion/build_conversion_use_case.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class RestoreLastConversionUseCase extends UseCaseNoInput<ConversionBuilt> {
  final ConversionRepository conversionRepository;
  final UnitGroupRepository unitGroupRepository;
  final UnitRepository unitRepository;
  final BuildConversionUseCase buildConversionUseCase;

  const RestoreLastConversionUseCase({
    required this.conversionRepository,
    required this.unitGroupRepository,
    required this.unitRepository,
    required this.buildConversionUseCase,
  });

  @override
  Future<Either<Failure, ConversionBuilt>> execute() async {
    UnitGroupModel? conversionUnitGroup;
    ConversionItemModel? sourceConversionItem;
    UnitModel? sourceUnit;
    String sourceValue = "";
    List<UnitModel> targetUnits = [];

    try {
      var conversionParamsResult =
          await conversionRepository.fetchLastConversion();

      if (conversionParamsResult.isLeft) {
        return Left(conversionParamsResult.left);
      }

      ConversionModel conversion = conversionParamsResult.right;

      if (conversion.conversionUnitGroupId != null) {
        var unitGroupResult = await unitGroupRepository
            .getUnitGroup(conversion.conversionUnitGroupId!);

        if (unitGroupResult.isLeft) {
          throw unitGroupResult.left;
        }

        conversionUnitGroup = unitGroupResult.right;
      }

      if (conversion.sourceUnitId != null) {
        var unitResult = await unitRepository.getUnit(conversion.sourceUnitId!);

        if (unitResult.isLeft) {
          throw unitResult.left;
        }

        sourceUnit = unitResult.right;
      }

      if (conversion.targetUnitIds != null &&
          conversion.targetUnitIds!.isNotEmpty) {
        var targetUnitsResult =
            await unitRepository.getUnits(conversion.targetUnitIds!);

        if (targetUnitsResult.isLeft) {
          throw targetUnitsResult.left;
        }

        targetUnits = targetUnitsResult.right;
      }

      if (sourceUnit != null) {
        sourceConversionItem = ConversionItemModel(
          unit: sourceUnit,
          value: ValueModel(
            strValue: sourceValue,
          ),
          defaultValue: const ValueModel(
            strValue: "1",
          ),
        );
      }

      return await buildConversionUseCase.execute(
        BuildConversion(
          unitGroup: conversionUnitGroup,
          sourceConversionItem: sourceConversionItem,
          units: targetUnits,
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error when restoring the last conversion: $e"),
      );
    }
  }
}
