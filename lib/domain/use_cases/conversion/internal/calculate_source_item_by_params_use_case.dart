import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_list_values_init_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_source_item_by_params_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateSourceItemByParamsUseCase
    extends UseCase<InputSourceItemByParamsModel, ConversionUnitValueModel> {
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;
  final InitUnitListValuesUseCase initUnitListValuesUseCase;

  const CalculateSourceItemByParamsUseCase({
    required this.calculateDefaultValueUseCase,
    required this.initUnitListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionUnitValueModel>> execute(
    InputSourceItemByParamsModel input,
  ) async {
    bool paramsMandatoryOrFull = input.params != null &&
        (input.params!.hasAllValues || input.params!.paramSet.mandatory);

    ValueModel? defaultValue = ObjectUtils.tryGet(
      await calculateDefaultValueUseCase.execute(
        InputDefaultValueCalculationModel(
          item: input.oldSourceUnitValue.unit,
        ),
      ),
    );

    ConversionUnitValueModel modifiedSourceUnitValue;

    if (!paramsMandatoryOrFull) {
      modifiedSourceUnitValue = input.oldSourceUnitValue.hasValue
          ? input.oldSourceUnitValue
          : ConversionUnitValueModel(
              unit: input.oldSourceUnitValue.unit,
              value: input.oldSourceUnitValue.unit.listType != null
                  ? defaultValue
                  : null,
              defaultValue: input.oldSourceUnitValue.unit.listType != null
                  ? null
                  : defaultValue,
            );
    } else {
      modifiedSourceUnitValue = rules.calculateSrcValueByParams(
        params: input.params!,
        unitGroup: input.unitGroup,
        srcUnit: input.oldSourceUnitValue.unit,
        defaultValue: defaultValue,
      );
    }

    if (modifiedSourceUnitValue.listType != null) {
      modifiedSourceUnitValue = ObjectUtils.tryGet(
        await initUnitListValuesUseCase.execute(
          InputUnitListValuesInitModel(
            itemValue: modifiedSourceUnitValue,
            paramSetValue: input.params,
          ),
        ),
      );
    }

    return Right(modifiedSourceUnitValue);
  }
}
