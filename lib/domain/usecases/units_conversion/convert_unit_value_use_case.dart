import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/units_conversion_events.dart';
import 'package:convertouch/domain/model/output/units_conversion_states.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/usecases/units_conversion/formulas_map.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:convertouch/domain/utils/unit_value_utils.dart';
import 'package:either_dart/either.dart';

class ConvertUnitValueUseCase
    extends UseCase<BuildConversion, ConversionBuilt> {
  @override
  Future<Either<Failure, ConversionBuilt>> execute(
      BuildConversion input) async {
    return Future(() {
      try {
        ConversionItemModel? sourceConversionItem = input.sourceConversionItem;
        List<ConversionItemModel> convertedUnitValues = [];

        if (input.units != null && input.unitGroup != null) {
          sourceConversionItem ??= ConversionItemModel.fromStrValue(
            unit: input.units![0],
            strValue: "1",
          );

          double? inputValue =
              double.tryParse(sourceConversionItem.value.strValue);
          double? inputUnitCoefficient = sourceConversionItem.unit.coefficient;

          for (UnitModel targetUnit in input.units!) {
            double? targetUnitCoefficient = targetUnit.coefficient;
            double? targetValue;

            if (inputUnitCoefficient != null && targetUnitCoefficient != null) {
              targetValue = inputValue != null
                  ? inputValue * inputUnitCoefficient / targetUnitCoefficient
                  : null;
            } else {
              String group = input.unitGroup!.name;
              String srcUnit = sourceConversionItem.unit.name;
              String tgtUnit = targetUnit.name;

              var srcToSi = getFormula(group, srcUnit);
              var siToTgt = getFormula(group, tgtUnit);

              double? siValue = srcToSi.applyForward(inputValue);
              targetValue = siToTgt.applyReverse(siValue);
            }

            convertedUnitValues.add(
              ConversionItemModel(
                unit: targetUnit,
                value: ValueModel(
                  strValue: UnitValueUtils.formatValue(targetValue),
                  scientificValue:
                      UnitValueUtils.formatValueInScientificNotation(
                          targetValue),
                ),
              ),
            );
          }
        }

        return Right(
          ConversionBuilt(
            unitGroup: input.unitGroup,
            sourceConversionItem: sourceConversionItem,
            conversionItems: convertedUnitValues,
          ),
        );
      } catch (e) {
        return Left(
          InternalFailure("Error when converting unit value: $e"),
        );
      }
    });
  }
}
