import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_list_values_init_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_non_list_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateUnitValueUseValue extends UseCase<InputUnitValueCalculationModel,
    OutputUnitValueCalculationModel> {
  final CalculateNonListDefaultValueUseCase calculateDefaultValueUseCase;
  final InitUnitListValuesUseCase initUnitListValuesUseCase;
  final UnitGroupRepository unitGroupRepository;

  const CalculateUnitValueUseValue({
    required this.calculateDefaultValueUseCase,
    required this.initUnitListValuesUseCase,
    required this.unitGroupRepository,
  });

  @override
  Future<Either<ConvertouchException, OutputUnitValueCalculationModel>> execute(
    InputUnitValueCalculationModel input,
  ) async {
    ConversionSingleUnitModifyDelta? delta = input.delta;
    ConversionUnitValueModel unitValue = input.itemValue;

    ValueModel? newValue = unitValue.value;
    ValueModel? newDefaultValue = unitValue.defaultValue;
    UnitModel? newUnit = unitValue.unit;

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
            unitValue: unitValue,
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
        srcUnit: unitValue.unit,
        params: input.paramSetValue!,
        unitGroupName: input.unitGroupName!,
      );
    }

    if (unitValue.listType == null) {
      if (calculatedValueByParams != null && calculatedValueByParams.hasValue) {
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
                    item: unitValue.unit,
                    replacingUnit: newUnit,
                  ),
                ),
              )
            : newDefaultValue;
      }

      return Right(
        OutputUnitValueCalculationModel(
          itemValue: unitValue.copyWith(
            unit: newUnit,
            value: newValue ?? ValueModel.empty,
            defaultValue: newDefaultValue ?? ValueModel.empty,
          ),
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
              itemValue: unitValue.copyWith(
                value: newValue ?? ValueModel.empty,
                unit: newUnit,
              ),
              paramSetValue: input.paramSetValue,
              alignSelectedValue: input.alignCurrentValue,
              fetchListValues: input.fetchListValues,
              keepSelectedValueIfNotInList:
                  input.keepSelectedValueIfNotInList ||
                      !paramsNotExistOrApplicable,
              onListValuesFetched: input.onItemValueUpdated,
            ),
          ),
        ),
      );
    }
  }
}
