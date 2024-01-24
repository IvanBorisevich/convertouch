import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/prepare_source_conversion_item_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:convertouch/domain/utils/formula_utils.dart';
import 'package:convertouch/domain/utils/number_value_utils.dart';
import 'package:either_dart/either.dart';

class BuildConversionUseCase
    extends UseCase<InputConversionModel, OutputConversionModel> {
  final PrepareSourceConversionItemUseCase prepareSourceConversionItemUseCase;

  const BuildConversionUseCase({
    required this.prepareSourceConversionItemUseCase,
  });

  @override
  Future<Either<Failure, OutputConversionModel>> execute(
    InputConversionModel input,
  ) async {
    try {
      if (input.unitGroup == null ||
          input.targetUnits.isEmpty) {
        return Right(
          OutputConversionModel(
            unitGroup: input.unitGroup,
            sourceConversionItem: null,
          ),
        );
      }

      ConversionItemModel srcConversionItem = input.sourceConversionItem ??
          ObjectUtils.tryGet(
            await prepareSourceConversionItemUseCase
                .execute(input.targetUnits[0]),
          );

      List<ConversionItemModel> convertedUnitValues = [];

      double? srcValue = double.tryParse(srcConversionItem.value.strValue);
      double? srcDefaultValue =
          double.tryParse(srcConversionItem.defaultValue.strValue);
      double? srcCoefficient = srcConversionItem.unit.coefficient;

      for (UnitModel tgtUnit in input.targetUnits) {
        if (tgtUnit.id! == srcConversionItem.unit.id!) {
          convertedUnitValues.add(srcConversionItem);
          continue;
        }

        double? tgtCoefficient = tgtUnit.coefficient;
        double? tgtValue;
        double? tgtDefaultValue;

        if (input.unitGroup!.conversionType != ConversionType.formula) {
          double? normalizedBaseValue =
              srcCoefficient != null && tgtCoefficient != null
                  ? srcCoefficient / tgtCoefficient
                  : null;
          tgtValue = srcValue != null && normalizedBaseValue != null
              ? srcValue * normalizedBaseValue
              : null;
          tgtDefaultValue =
              srcDefaultValue != null && normalizedBaseValue != null
                  ? srcDefaultValue * normalizedBaseValue
                  : null;
        } else {
          String groupName = input.unitGroup!.name;

          var srcToBase = FormulaUtils.getFormula(
            groupName,
            srcConversionItem.unit.name,
          );
          var baseToTgt = FormulaUtils.getFormula(groupName, tgtUnit.name);

          double? baseValue = srcToBase.applyForward(srcValue);
          double? normalizedBaseValue = srcToBase.applyForward(srcDefaultValue);

          tgtValue = baseToTgt.applyReverse(baseValue);
          tgtDefaultValue = baseToTgt.applyReverse(normalizedBaseValue)!;
        }

        convertedUnitValues.add(
          ConversionItemModel(
            unit: tgtUnit,
            value: ValueModel(
              strValue: NumberValueUtils.formatValue(
                tgtValue,
              ),
              scientificValue: NumberValueUtils.formatValueInScientificNotation(
                tgtValue,
              ),
            ),
            defaultValue: ValueModel(
              strValue: NumberValueUtils.formatValue(
                tgtDefaultValue,
              ),
              scientificValue: NumberValueUtils.formatValueInScientificNotation(
                tgtDefaultValue,
              ),
            ),
          ),
        );
      }

      return Right(
        OutputConversionModel(
          unitGroup: input.unitGroup,
          sourceConversionItem: srcConversionItem,
          targetConversionItems: convertedUnitValues,
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error when converting unit value: $e"),
      );
    }
  }
}
