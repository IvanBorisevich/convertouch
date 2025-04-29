import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/conversion_rule.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_single_value_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart';
import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:either_dart/either.dart';

class ConvertSingleValueUseCase
    extends UseCase<InputSingleValueConversionModel, ConversionUnitValueModel> {
  const ConvertSingleValueUseCase();

  @override
  Future<Either<ConvertouchException, ConversionUnitValueModel>> execute(
    InputSingleValueConversionModel input,
  ) async {
    if (input.tgtUnit.id == input.srcItem.unit.id) {
      return Right(input.srcItem);
    }

    try {
      ValueModel? tgt = _calculate(
        src: input.srcItem.value,
        srcUnit: input.srcItem.unit,
        tgtUnit: input.tgtUnit,
        unitGroup: input.unitGroup,
        paramSetValue: input.params,
      );

      ValueModel? tgtDef;
      if (input.tgtUnit.listType == null) {
        tgtDef = _calculate(
          src: input.srcItem.defaultValue,
          srcUnit: input.srcItem.unit,
          tgtUnit: input.tgtUnit,
          unitGroup: input.unitGroup,
          paramSetValue: input.params,
        );
      }

      return Right(
        ConversionUnitValueModel(
          unit: input.tgtUnit,
          value: tgt,
          defaultValue: tgtDef,
        ),
      );
    } catch (e, stackTrace) {
      return Left(InternalException(
        message: "Error when converting a single value "
            "${input.srcItem.value?.raw} "
            "from ${input.srcItem.unit.name} to ${input.tgtUnit.name}",
        stackTrace: stackTrace,
        dateTime: DateTime.now(),
      ));
    }
  }

  ValueModel? _calculate({
    required ValueModel? src,
    required UnitModel srcUnit,
    required UnitModel tgtUnit,
    required UnitGroupModel unitGroup,
    ConversionParamSetValueModel? paramSetValue,
  }) {
    ConversionRule srcUnitRule;
    ConversionRule tgtUnitRule;

    if (src == null) {
      return null;
    }

    switch (unitGroup.conversionType) {
      case ConversionType.formula:
        srcUnitRule = ConversionRuleUtils.getFormulaRule(
          unitGroupName: unitGroup.name,
          unitCode: srcUnit.code,
        );
        tgtUnitRule = ConversionRuleUtils.getFormulaRule(
          unitGroupName: unitGroup.name,
          unitCode: tgtUnit.code,
        );
      case ConversionType.static:
      case ConversionType.dynamic:
        srcUnitRule = ConversionRule.fromCoefficient(srcUnit.coefficient!);
        tgtUnitRule = ConversionRule.fromCoefficient(tgtUnit.coefficient!);
    }

    ValueModel? result = ConversionRuleUtils.calculate(
      src,
      srcUnitRule: srcUnitRule,
      tgtUnitRule: tgtUnitRule,
      params: paramSetValue,
    );

    bool isValueInRange = DoubleValueUtils.between(
      value: result?.numVal,
      min: tgtUnit.minValue?.numVal,
      max: tgtUnit.maxValue?.numVal,
    );

    return isValueInRange ? result : null;
  }
}
