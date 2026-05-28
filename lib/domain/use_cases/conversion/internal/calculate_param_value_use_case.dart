import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_list_values_init_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_value_calculation_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateParamValueUseValue extends UseCase<
    InputParamValueCalculationModel, ConversionParamValueModel> {
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;
  final InitParamListValuesUseCase initParamListValuesUseCase;
  final UnitGroupRepository unitGroupRepository;

  const CalculateParamValueUseValue({
    required this.calculateDefaultValueUseCase,
    required this.initParamListValuesUseCase,
    required this.unitGroupRepository,
  });

  @override
  Future<Either<ConvertouchException, ConversionParamValueModel>> execute(
    InputParamValueCalculationModel input,
  ) async {
    ConversionSingleParamModifyDelta? delta = input.delta;
    ValueModel? newValue = input.paramValue.value;
    ValueModel? newDefaultValue = input.paramValue.defaultValue;
    UnitModel? newUnit = input.paramValue.unit;

    ValueModel? newDefaultValueForNewUnit;

    if (delta is EditConversionParamValueDelta) {
      newValue = delta.newValue;
      newDefaultValue = delta.newDefaultValue;
    } else if (delta is ReplaceConversionParamUnitDelta) {
      newUnit = delta.newUnit;

      UnitGroupModel? paramUnitGroup = ObjectUtils.tryGet(
        await unitGroupRepository.get(newUnit.unitGroupId),
      );

      if (paramUnitGroup != null) {
        var paramValueForNewUnit = rules.calculateParamValueForNewUnit(
          paramValue: input.paramValue,
          tgtParamUnit: newUnit,
          params: input.paramSetValue,
          paramUnitGroup: paramUnitGroup,
        );

        newValue = paramValueForNewUnit.value;
        newDefaultValueForNewUnit = paramValueForNewUnit.defaultValue;
      }
    }

    ValueModel? autoCalculatedValue;

    if (delta == null && input.paramValue.calculated) {
      autoCalculatedValue =
          input.srcUnitValue != null && input.unitGroupName != null
              ? rules.calculateParamValueBySrcValue(
                  srcUnitValue: input.srcUnitValue!,
                  unitGroupName: input.unitGroupName!,
                  params: input.paramSetValue,
                  param: input.paramValue.param,
                )
              : null;
    }

    if (input.paramValue.listType == null) {
      if (autoCalculatedValue != null) {
        newValue = null;
        newDefaultValue = autoCalculatedValue;
      } else if (newDefaultValueForNewUnit != null) {
        newDefaultValue = newDefaultValueForNewUnit;
      } else {
        newDefaultValue = newDefaultValue == null && input.alignCurrentValue
            ? ObjectUtils.tryGet(
                await calculateDefaultValueUseCase.execute(
                  InputDefaultValueCalculationModel(
                    item: input.paramValue.param,
                    currentParamUnit: input.paramValue.unit,
                    replacingUnit: newUnit,
                  ),
                ),
              )
            : newDefaultValue;
      }

      return Right(
        ConversionParamValueModel(
          param: input.paramValue.param,
          unit: newUnit,
          value: newValue,
          defaultValue: newDefaultValue,
          calculated: input.paramValue.calculated,
          listValues: input.paramValue.listValues,
        ),
      );
    } else {
      if (autoCalculatedValue != null) {
        newValue = autoCalculatedValue;
      }

      return Right(
        ObjectUtils.tryGet(
          await initParamListValuesUseCase.execute(
            InputParamListValuesInitModel(
              itemValue: ConversionParamValueModel(
                param: input.paramValue.param,
                value: newValue,
                unit: newUnit,
                calculated: input.paramValue.calculated,
              ),
              paramSetValue: input.paramSetValue,
              alignSelectedValue: input.alignCurrentValue,
            ),
          ),
        ),
      );
    }
  }
}
