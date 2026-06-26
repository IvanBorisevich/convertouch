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

class CalculateParamValueUseValue extends UseCase<
    InputParamValueCalculationModel, OutputParamValueCalculationModel> {
  final CalculateNonListDefaultValueUseCase calculateDefaultValueUseCase;
  final InitParamListValuesUseCase initParamListValuesUseCase;
  final UnitGroupRepository unitGroupRepository;

  const CalculateParamValueUseValue({
    required this.calculateDefaultValueUseCase,
    required this.initParamListValuesUseCase,
    required this.unitGroupRepository,
  });

  @override
  Future<Either<ConvertouchException, OutputParamValueCalculationModel>>
      execute(InputParamValueCalculationModel input) async {
    ConversionSingleParamModifyDelta? delta = input.delta;
    ConversionParamValueModel paramValue = input.itemValue;

    ValueModel? newValue = paramValue.value;
    ValueModel? newDefaultValue = paramValue.defaultValue;
    UnitModel? newUnit = paramValue.unit;

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
          paramValue: paramValue,
          tgtParamUnit: newUnit,
          params: input.paramSetValue,
          paramUnitGroup: paramUnitGroup,
        );

        newValue = paramValueForNewUnit.value;
        newDefaultValueForNewUnit = paramValueForNewUnit.defaultValue;
      }
    }

    ValueModel? autoCalculatedValue;

    if (delta == null && paramValue.calculated) {
      autoCalculatedValue =
          input.srcUnitValue != null && input.unitGroupName != null
              ? rules.calculateParamValueBySrcValue(
                  srcUnitValue: input.srcUnitValue!,
                  unitGroupName: input.unitGroupName!,
                  params: input.paramSetValue,
                  param: paramValue.param,
                )
              : null;
    }

    if (paramValue.listType == null) {
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
                    item: paramValue.param,
                    currentParamUnit: paramValue.unit,
                    replacingUnit: newUnit,
                  ),
                ),
              )
            : newDefaultValue;
      }

      final resultParamValue = paramValue.copyWith(
        unit: newUnit,
        value: newValue ?? ValueModel.empty,
        defaultValue: newDefaultValue ?? ValueModel.empty,
      );

      input.onItemValueUpdated?.call(resultParamValue);

      return Right(
        OutputParamValueCalculationModel(
          itemValue: resultParamValue,
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
              itemValue: paramValue.copyWith(
                value: newValue ?? ValueModel.empty,
                unit: newUnit,
              ),
              paramSetValue: input.paramSetValue,
              alignSelectedValue: input.alignCurrentValue,
              fetchListValues: input.fetchListValues,
              keepSelectedValueIfNotInList: input.keepSelectedValueIfNotInList,
              onListValuesFetched: input.onItemValueUpdated,
            ),
          ),
        ),
      );
    }
  }
}
