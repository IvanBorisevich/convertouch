import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/formula.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_single_value_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/formula_utils.dart';
import 'package:convertouch/domain/utils/value_model_utils.dart';
import 'package:either_dart/either.dart';

class ConvertSingleValueUseCase
    extends UseCase<InputSingleValueConversionModel, ConversionUnitValueModel> {
  const ConvertSingleValueUseCase();

  @override
  Future<Either<ConvertouchException, ConversionUnitValueModel>> execute(
    InputSingleValueConversionModel input,
  ) async {
    double? tgtValue;
    double tgtDefaultValue;

    if (input.tgtUnit.id == input.srcItem.unit.id) {
      return Right(input.srcItem);
    }

    double? srcValue = double.tryParse(input.srcItem.value.str);
    double srcDefaultValue = double.parse(input.srcItem.defaultValue.str);

    try {
      if (input.unitGroup.conversionType != ConversionType.formula) {
        var srcCoefficient = input.srcItem.unit.coefficient!;
        var tgtCoefficient = input.tgtUnit.coefficient!;

        tgtValue = _calculateValueByCoefficient(
          srcValue: srcValue,
          srcCoefficient: srcCoefficient,
          tgtCoefficient: tgtCoefficient,
        );

        tgtDefaultValue = _calculateValueByCoefficient(
          srcValue: srcDefaultValue,
          srcCoefficient: srcCoefficient,
          tgtCoefficient: tgtCoefficient,
        )!;
      } else {
        var srcFormula = FormulaUtils.getFormula(
          unitGroupName: input.unitGroup.name,
          unitCode: input.srcItem.unit.code,
        );
        var tgtFormula = FormulaUtils.getFormula(
          unitGroupName: input.unitGroup.name,
          unitCode: input.tgtUnit.code,
        );

        tgtValue = _calculateValueByFormula(
          srcValue: srcValue,
          srcFormula: srcFormula,
          tgtFormula: tgtFormula,
        );

        tgtDefaultValue = _calculateValueByFormula(
          srcValue: srcDefaultValue,
          srcFormula: srcFormula,
          tgtFormula: tgtFormula,
        )!;
      }

      /*
       TODO:
        1) use the pattern Chain of responsibility or similar
        2) support generic type (not only double)
       */

      double? minValue =
          (input.tgtUnit.minValue ?? input.unitGroup.minValue).num;
      double? maxValue =
          (input.tgtUnit.maxValue ?? input.unitGroup.maxValue).num;

      ValueModel tgtValueModel = ValueModelUtils.betweenOrNone(
        rawValue: tgtValue,
        min: minValue,
        max: maxValue,
      );

      ValueModel tgtDefaultValueModel = ValueModelUtils.betweenOrNone(
        rawValue: tgtDefaultValue,
        min: minValue,
        max: maxValue,
      );

      return Right(
        ConversionUnitValueModel(
          unit: input.tgtUnit,
          value: tgtValueModel.exists ? tgtValueModel : ValueModel.none,
          defaultValue: tgtDefaultValueModel.exists
              ? tgtDefaultValueModel
              : ValueModel.nan,
        ),
      );
    } catch (e, stackTrace) {
      return Left(InternalException(
        message: "Error when converting a single value "
            "${input.srcItem.value.str} "
            "from ${input.srcItem.unit.name} to ${input.tgtUnit.name}",
        stackTrace: stackTrace,
        dateTime: DateTime.now(),
      ));
    }
  }

  double? _calculateValueByCoefficient({
    required double? srcValue,
    required double srcCoefficient,
    required double tgtCoefficient,
  }) {
    return srcValue != null ? srcValue * srcCoefficient / tgtCoefficient : null;
  }

  double? _calculateValueByFormula({
    required double? srcValue,
    required ConvertouchFormula srcFormula,
    required ConvertouchFormula tgtFormula,
  }) {
    double? baseValue = srcFormula.applyForward(srcValue);
    return tgtFormula.applyReverse(baseValue);
  }
}
