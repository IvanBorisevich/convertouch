import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_non_list_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateUnitValueUseValue
    extends UseCase<InputUnitValueCalculationModel, ConversionUnitValueModel> {
  final CalculateNonListDefaultValueUseCase calculateDefaultValueUseCase;
  final FetchListValuesUseCase fetchListValuesUseCase;
  final UnitGroupRepository unitGroupRepository;

  const CalculateUnitValueUseValue({
    required this.calculateDefaultValueUseCase,
    required this.fetchListValuesUseCase,
    required this.unitGroupRepository,
  });

  @override
  Future<Either<ConvertouchException, ConversionUnitValueModel>> execute(
    InputUnitValueCalculationModel input,
  ) async {
    ConversionSingleUnitModifyDelta? delta = input.delta;
    ConversionUnitValueModel unitValue = input.itemValue;

    if (delta is EditConversionUnitValueDelta) {
      unitValue = unitValue.copyWith(
        value: Patchable(delta.newValue, patchNull: true),
        defaultValue: Patchable(delta.newDefaultValue, patchNull: true),
      );
    } else if (delta is ReplaceConversionItemUnitDelta) {
      if (delta.recalculationMode == RecalculationOnUnitChange.currentValue) {
        UnitGroupModel? paramUnitGroup = ObjectUtils.tryGet(
          await unitGroupRepository.get(delta.newUnit.unitGroupId),
        );

        if (paramUnitGroup != null) {
          var unitValueForNewUnit = rules.calculateUnitValueForNewUnit(
            unitValue: unitValue,
            paramUnitGroup: paramUnitGroup,
            tgtParamUnit: delta.newUnit,
            params: input.paramSetValue,
          );

          unitValue = ConversionUnitValueModel(
            unit: delta.newUnit,
            value: unitValueForNewUnit.value,
            defaultValue: unitValueForNewUnit.defaultValue,
          );
        } else {
          ValueModel? newDefaultValue = ObjectUtils.tryGet(
            await calculateDefaultValueUseCase.execute(
              InputDefaultValueCalculationModel(
                item: unitValue.unit,
                conversionGroupName: input.unitGroupName,
                replacingUnit: delta.newUnit,
              ),
            ),
          );

          unitValue = ConversionUnitValueModel(
            unit: delta.newUnit,
            value: null,
            defaultValue: newDefaultValue,
          );
        }
      } else {
        unitValue = unitValue.copyWith(
          unit: delta.newUnit,
        );
      }
    } else if (delta == null &&
        input.calculateByParams &&
        areParamsApplicable(input.paramSetValue)) {
      ConversionUnitValueModel? calculatedValueByParams =
          rules.calculateSrcValueByParams(
        srcUnit: unitValue.unit,
        params: input.paramSetValue!,
        unitGroupName: input.unitGroupName,
      );

      unitValue = unitValue.copyWith(
        value: Patchable(calculatedValueByParams.value, patchNull: true),
        defaultValue:
            Patchable(calculatedValueByParams.defaultValue, patchNull: true),
      );
    }

    bool paramsNotExistOrApplicable =
        areParamsNullOrApplicable(input.paramSetValue);

    if (unitValue.listType == null) {
      ValueModel? newDefaultValue =
          unitValue.defaultValue == null && paramsNotExistOrApplicable
              ? ObjectUtils.tryGet(
                  await calculateDefaultValueUseCase.execute(
                    InputDefaultValueCalculationModel(
                      item: unitValue.unit,
                      conversionGroupName: input.unitGroupName,
                    ),
                  ),
                )
              : unitValue.defaultValue;

      return Right(
        unitValue.copyWith(
          defaultValue: Patchable(newDefaultValue, patchNull: true),
        ),
      );
    } else {
      ListValuesFetchResult listValuesFetchResult = ObjectUtils.tryGet(
        await fetchListValuesUseCase.execute(
          InputItemsFetchModel(
            pageSize: listValuesPageSize,
            pageNum: 0,
            fetchParams: ListValuesFetchParams(
              itemId: unitValue.id,
              listType: unitValue.listType!,
              selectedValue: unitValue.value,
              unit: unitValue.unit,
              conversionGroupName: input.unitGroupName,
              params: input.paramSetValue,
              keepSelectedValueIfNotInList: !paramsNotExistOrApplicable,
            ),
          ),
        ),
      );

      return Right(
        unitValue.copyWith(
          value: Patchable(listValuesFetchResult.selectedItem, patchNull: true),
          defaultValue: const Patchable(null, patchNull: true),
          listValuesFetchResult: Patchable(listValuesFetchResult),
        ),
      );
    }
  }
}
