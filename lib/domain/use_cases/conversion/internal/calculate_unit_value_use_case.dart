import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_list_values_init_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_unit_value_calculation_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateUnitValueUseValue
    extends UseCase<InputUnitValueCalculationModel, ConversionUnitValueModel> {
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;
  final InitUnitListValuesUseCase initUnitListValuesUseCase;
  final UnitGroupRepository unitGroupRepository;

  const CalculateUnitValueUseValue({
    required this.calculateDefaultValueUseCase,
    required this.initUnitListValuesUseCase,
    required this.unitGroupRepository,
  });

  @override
  Future<Either<ConvertouchException, ConversionUnitValueModel>> execute(
    InputUnitValueCalculationModel input,
  ) async {
    ConversionSingleUnitModifyDelta? delta = input.delta;
    ValueModel? newValue = input.unitValue.value;
    ValueModel? newDefaultValue = input.unitValue.defaultValue;
    UnitModel? newUnit = input.unitValue.unit;

    ValueModel? newDefaultValueForNewUnit;

    if (delta is EditConversionUnitValueDelta) {
      newValue = delta.newValue;
      newDefaultValue = delta.newDefaultValue;
    } else if (delta is ReplaceConversionItemUnitDelta) {
      newUnit = delta.newUnit;

      if (delta.recalculationMode == RecalculationOnUnitChange.currentValue) {
        UnitGroupModel? paramUnitGroup = ObjectUtils.tryGet(
          await unitGroupRepository.get(newUnit.unitGroupId),
        );

        if (paramUnitGroup != null) {
          var unitValueForNewUnit = rules.calculateUnitValueForNewUnit(
            unitValue: input.unitValue,
            paramUnitGroup: paramUnitGroup,
            tgtParamUnit: newUnit,
            params: input.paramSetValue,
          );

          newValue = unitValueForNewUnit.value;
          newDefaultValueForNewUnit = unitValueForNewUnit.defaultValue;
        }
      }
    }

    bool paramsAreApplicable = areParamsApplicable(input.paramSetValue);
    bool paramsNotExistOrApplicable =
        areParamsNullOrApplicable(input.paramSetValue);

    ConversionUnitValueModel? calculatedValueByParams;

    if (delta == null &&
        input.calculateByParams &&
        paramsAreApplicable &&
        input.unitGroupName != null) {
      calculatedValueByParams = rules.calculateSrcValueByParams(
        srcUnit: input.unitValue.unit,
        params: input.paramSetValue!,
        unitGroupName: input.unitGroupName!,
      );
    }

    if (input.unitValue.listType == null) {
      if (calculatedValueByParams != null) {
        newValue = calculatedValueByParams.value;
        newDefaultValue = calculatedValueByParams.defaultValue;
      } else if (newDefaultValueForNewUnit != null) {
        newDefaultValue = newDefaultValueForNewUnit;
      } else {
        newDefaultValue = newDefaultValue == null &&
                input.alignCurrentValue &&
                paramsNotExistOrApplicable
            ? ObjectUtils.tryGet(
                await calculateDefaultValueUseCase.execute(
                  InputDefaultValueCalculationModel(
                    item: input.unitValue.unit,
                    replacingUnit: newUnit,
                  ),
                ),
              )
            : newDefaultValue;
      }

      return Right(
        ConversionUnitValueModel(
          unit: newUnit,
          value: newValue,
          defaultValue: newDefaultValue,
        ),
      );
    } else {
      if (calculatedValueByParams != null) {
        newValue = calculatedValueByParams.value;
      }

      return Right(
        ObjectUtils.tryGet(
          await initUnitListValuesUseCase.execute(
            InputUnitListValuesInitModel(
              itemValue: ConversionUnitValueModel(
                value: newValue,
                unit: newUnit,
              ),
              paramSetValue: input.paramSetValue,
              alignSelectedValue: input.alignCurrentValue,
              alignForNull: !paramsNotExistOrApplicable,
            ),
          ),
        ),
      );
    }
  }
}
