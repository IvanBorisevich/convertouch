import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_source_item_by_params_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateSourceItemByParamsUseCase
    extends UseCase<InputSourceItemByParamsModel, ConversionUnitValueModel> {
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const CalculateSourceItemByParamsUseCase({
    required this.calculateDefaultValueUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionUnitValueModel>> execute(
      InputSourceItemByParamsModel input) async {
    UnitModel srcUnit = input.oldSourceUnitValue.unit;

    if (input.params == null ||
        !input.params!.paramSet.mandatory && !input.params!.hasAllValues) {
      return Right(
        input.oldSourceUnitValue.hasValue
            ? input.oldSourceUnitValue
            : await _calculateDefaults(srcUnit),
      );
    }

    if (input.params!.hasAllValues || input.params!.paramSet.mandatory) {
      return Right(
        rules.calculateSrcValueByParams(
          params: input.params!,
          unitGroupName: input.unitGroupName,
          srcUnit: srcUnit,
        ),
      );
    }

    return Right(input.oldSourceUnitValue);
  }

  Future<ConversionUnitValueModel> _calculateDefaults(UnitModel srcUnit) async {
    ValueModel? defaultValue = ObjectUtils.tryGet(
      await calculateDefaultValueUseCase.execute(
        InputDefaultValueCalculationModel(
            item: srcUnit,
        ),
      ),
    );
    return ConversionUnitValueModel(
      unit: srcUnit,
      value: srcUnit.listType != null ? defaultValue : null,
      defaultValue: srcUnit.listType != null ? null : defaultValue,
    );
  }
}
