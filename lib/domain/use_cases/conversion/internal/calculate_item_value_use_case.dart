import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_non_list_default_value_calculation_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_non_list_default_value_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class CalculateItemValueUseCase<
    I extends InputItemValueCalculationModel<O, ConversionModifyDelta>,
    O extends ItemValueModel> extends UseCase<I, O> {
  final CalculateNonListDefaultValueUseCase calculateDefaultValueUseCase;
  final FetchListValuesUseCase fetchListValuesUseCase;

  const CalculateItemValueUseCase({
    required this.calculateDefaultValueUseCase,
    required this.fetchListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, O>> execute(I input) async {
    ConversionModifyDelta? delta = input.delta;
    O itemValue = input.itemValue;

    if (delta is EditItemValueDelta) {
      itemValue = itemValue.copyWith(
        value: Patchable(delta.newValue, patchNull: true),
        defaultValue: Patchable(delta.newDefaultValue, patchNull: true),
      ) as O;
    } else if (delta is ReplaceItemUnitDelta) {
      itemValue = await replaceItemUnit(itemValue, delta, input);
    } else if (delta == null) {
      itemValue = calculateWithoutDelta(itemValue, input);
    }

    if (itemValue.listType == null) {
      ValueModel? newDefaultValue = itemValue.defaultValue ??
          (input.initDefaultNonListValueIfEmpty
              ? await calculateDefaultNonListValue(itemValue, input)
              : null);

      return Right(
        itemValue.copyWith(
          defaultValue: Patchable(newDefaultValue, patchNull: true),
        ) as O,
      );
    } else {
      ListValuesFetchResult? listValuesFetchResult;
      ValueModel? selectedValue;

      if (itemValue.listType!.fetchedViaApi) {
        listValuesFetchResult = itemValue.listValuesFetchResult;
        selectedValue = itemValue.value;
      } else {
        ConversionParamSetValueModel? paramSetValue =
            input is InputParamValueCalculationModel
                ? (input as InputParamValueCalculationModel).paramSetValue
                : (input as InputUnitValueCalculationModel).paramSetValue;

        bool leaveEmptySelectedValue = input is InputUnitValueCalculationModel
            ? !areParamsNullOrApplicable(paramSetValue)
            : false;

        listValuesFetchResult = ObjectUtils.tryGet(
          await fetchListValuesUseCase.execute(
            InputItemsFetchModel(
              pageSize: listValuesPageSize,
              pageNum: 0,
              selectedItem: itemValue.value,
              fetchParams: ListValuesFetchParams(
                itemId: itemValue.id,
                listType: itemValue.listType!,
                unit: itemValue.unitItem,
                conversionGroupName: input.conversionGroup.name,
                conversionParams: paramSetValue,
                leaveEmptySelectedValue: leaveEmptySelectedValue,
              ),
            ),
          ),
        );

        selectedValue = listValuesFetchResult?.selectedItem;
      }

      return Right(
        itemValue.copyWith(
          value: Patchable(selectedValue, patchNull: true),
          defaultValue: const Patchable(null, patchNull: true),
          listValuesFetchResult: Patchable(listValuesFetchResult),
        ) as O,
      );
    }
  }

  Future<O> replaceItemUnit(
    O itemValue,
    ReplaceItemUnitDelta delta,
    I input,
  );

  O calculateWithoutDelta(O itemValue, I input);

  Future<ValueModel?> calculateDefaultNonListValue(O itemValue, I input);
}

//////////////////////////////////////////////////////////////////////////////

class CalculateParamValueUseValue extends CalculateItemValueUseCase<
    InputParamValueCalculationModel, ConversionParamValueModel> {
  final UnitGroupRepository unitGroupRepository;

  const CalculateParamValueUseValue({
    required super.calculateDefaultValueUseCase,
    required super.fetchListValuesUseCase,
    required this.unitGroupRepository,
  });

  @override
  Future<ConversionParamValueModel> replaceItemUnit(
    ConversionParamValueModel itemValue,
    ReplaceItemUnitDelta delta,
    InputParamValueCalculationModel input,
  ) async {
    UnitGroupModel? paramUnitGroup = ObjectUtils.tryGet(
      await unitGroupRepository.get(delta.newUnit.unitGroupId),
    );

    if (paramUnitGroup != null) {
      var paramValueForNewUnit = rules.calculateParamValueForNewUnit(
        paramValue: itemValue,
        tgtParamUnit: delta.newUnit,
        params: input.paramSetValue,
        paramUnitGroup: paramUnitGroup,
      );

      return ConversionParamValueModel(
        param: itemValue.param,
        calculated: itemValue.calculated,
        unit: delta.newUnit,
        value: paramValueForNewUnit.value,
        defaultValue: paramValueForNewUnit.defaultValue,
      );
    }

    return itemValue;
  }

  @override
  ConversionParamValueModel calculateWithoutDelta(
    ConversionParamValueModel itemValue,
    InputParamValueCalculationModel input,
  ) {
    if (!itemValue.calculated || input.srcUnitValue == null) {
      return itemValue;
    }

    ValueModel? calculatedBySrcValue = rules.calculateParamValueBySrcValue(
      srcUnitValue: input.srcUnitValue!,
      unitGroupName: input.conversionGroup.name,
      params: input.paramSetValue,
      param: itemValue.param,
    );

    if (itemValue.listType == null) {
      return itemValue.copyWith(
        value: const Patchable(null, patchNull: true),
        defaultValue: Patchable(calculatedBySrcValue, patchNull: true),
      );
    } else {
      return itemValue.copyWith(
        value: Patchable(calculatedBySrcValue, patchNull: true),
        defaultValue: const Patchable(null, patchNull: true),
      );
    }
  }

  @override
  Future<ValueModel?> calculateDefaultNonListValue(
    ConversionParamValueModel itemValue,
    InputParamValueCalculationModel input,
  ) async {
    if (itemValue.calculated &&
        (input.srcUnitValue != null || itemValue.value != null)) {
      return itemValue.defaultValue;
    }

    return ObjectUtils.tryGet(
      await calculateDefaultValueUseCase.execute(
        InputNonListDefaultValueCalculationModel(
          item: itemValue.param,
          conversionGroupName: input.conversionGroup.name,
          currentParamUnit: itemValue.unit,
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////

class CalculateUnitValueUseValue extends CalculateItemValueUseCase<
    InputUnitValueCalculationModel, ConversionUnitValueModel> {
  const CalculateUnitValueUseValue({
    required super.calculateDefaultValueUseCase,
    required super.fetchListValuesUseCase,
  });

  @override
  Future<ConversionUnitValueModel> replaceItemUnit(
    ConversionUnitValueModel itemValue,
    ReplaceItemUnitDelta delta,
    InputUnitValueCalculationModel input,
  ) async {
    if (delta.recalculationMode == RecalculationOnUnitChange.currentValue) {
      var unitValueForNewUnit = rules.calculateUnitValueForNewUnit(
        unitValue: itemValue,
        paramUnitGroup: input.conversionGroup,
        tgtParamUnit: delta.newUnit,
        params: input.paramSetValue,
      );

      return ConversionUnitValueModel(
        unit: delta.newUnit,
        value: unitValueForNewUnit.value,
        defaultValue: unitValueForNewUnit.defaultValue,
      );
    } else {
      return itemValue.copyWith(
        unit: delta.newUnit,
      );
    }
  }

  @override
  ConversionUnitValueModel calculateWithoutDelta(
    ConversionUnitValueModel itemValue,
    InputUnitValueCalculationModel input,
  ) {
    bool calculateByParams = !input.conversionGroup.refreshable;

    if (!calculateByParams || !areParamsApplicable(input.paramSetValue)) {
      return itemValue;
    }

    ConversionUnitValueModel? calculatedValueByParams =
        rules.calculateSrcValueByParams(
      srcUnit: itemValue.unit,
      params: input.paramSetValue!,
      unitGroupName: input.conversionGroup.name,
    );

    return itemValue.copyWith(
      value: Patchable(calculatedValueByParams.value, patchNull: true),
      defaultValue:
          Patchable(calculatedValueByParams.defaultValue, patchNull: true),
    );
  }

  @override
  Future<ValueModel?> calculateDefaultNonListValue(
    ConversionUnitValueModel itemValue,
    InputUnitValueCalculationModel input,
  ) async {
    bool calculateByParams = !input.conversionGroup.refreshable;

    if (calculateByParams && areParamsApplicable(input.paramSetValue)) {
      return itemValue.defaultValue;
    }

    return ObjectUtils.tryGet(
      await calculateDefaultValueUseCase.execute(
        InputNonListDefaultValueCalculationModel(
          item: itemValue.unit,
          conversionGroupName: input.conversionGroup.name,
        ),
      ),
    );
  }
}
