import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/conversion_events.dart';
import 'package:convertouch/domain/model/output/conversion_states.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/refreshable_value_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:convertouch/domain/utils/formula_utils.dart';
import 'package:convertouch/domain/utils/unit_value_utils.dart';
import 'package:either_dart/either.dart';

class BuildConversionUseCase extends UseCase<BuildConversion, ConversionBuilt> {
  final RefreshableValueRepository refreshableValueRepository;

  const BuildConversionUseCase({
    required this.refreshableValueRepository,
  });

  @override
  Future<Either<Failure, ConversionBuilt>> execute(
    BuildConversion input,
  ) async {
    try {
      ConversionItemModel? srcConversionItem = input.sourceConversionItem;
      UnitGroupModel? unitGroup = input.unitGroup;

      List<ConversionItemModel> convertedUnitValues = [];

      if (input.units != null && unitGroup != null) {
        if (srcConversionItem == null) {
          srcConversionItem = ConversionItemModel.fromUnit(
            unit: input.units![0],
          );
        } else {
          String? defaultSourceValue;
          var refreshableValueResult =
              await refreshableValueRepository.get(srcConversionItem.unit.id!);

          if (refreshableValueResult.isRight) {
            defaultSourceValue = refreshableValueResult.right?.value;
          }

          srcConversionItem = ConversionItemModel(
            unit: srcConversionItem.unit,
            value: srcConversionItem.value,
            defaultValue: ValueModel(
              strValue: defaultSourceValue ?? "1",
            ),
          );
        }

        double? srcValue = double.tryParse(srcConversionItem.value.strValue);
        double srcDefaultValue =
            double.parse(srcConversionItem.defaultValue.strValue);
        double? srcCoefficient = srcConversionItem.unit.coefficient;

        for (UnitModel tgtUnit in input.units!) {
          double? tgtCoefficient = tgtUnit.coefficient;
          double? tgtValue;
          double tgtDefaultValue;

          if (srcCoefficient != null && tgtCoefficient != null) {
            double normalizedBaseValue = srcCoefficient / tgtCoefficient;
            tgtValue = srcValue != null ? srcValue * normalizedBaseValue : null;
            tgtDefaultValue = srcDefaultValue * normalizedBaseValue;
          } else {
            String groupName = unitGroup.name;

            var srcToBase = FormulaUtils.getFormula(
              groupName,
              srcConversionItem.unit.name,
            );
            var baseToTgt = FormulaUtils.getFormula(groupName, tgtUnit.name);

            double? baseValue = srcToBase.applyForward(srcValue);
            tgtValue = baseToTgt.applyReverse(baseValue);

            double? normalizedBaseValue =
                srcToBase.applyForward(srcDefaultValue);
            tgtDefaultValue = baseToTgt.applyReverse(normalizedBaseValue)!;
          }

          String tgtStrValue = UnitValueUtils.formatValue(tgtValue);
          String tgtScientificValue =
              UnitValueUtils.formatValueInScientificNotation(tgtValue);

          String tgtDefaultStrValue =
              UnitValueUtils.formatValue(tgtDefaultValue);
          String tgtDefaultScientificValue =
              UnitValueUtils.formatValueInScientificNotation(tgtDefaultValue);

          convertedUnitValues.add(
            ConversionItemModel(
              unit: tgtUnit,
              value: ValueModel(
                strValue: tgtStrValue,
                scientificValue: tgtScientificValue,
              ),
              defaultValue: ValueModel(
                strValue: tgtDefaultStrValue,
                scientificValue: tgtDefaultScientificValue,
              ),
            ),
          );
        }
      }

      return Right(
        ConversionBuilt(
          unitGroup: unitGroup,
          sourceConversionItem: srcConversionItem,
          conversionItems: convertedUnitValues,
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error when converting unit value: $e"),
      );
    }
  }
}
