import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
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

class CalculateParamValueUseValue extends UseCase<
    InputParamValueCalculationModel, ConversionParamValueModel> {
  final CalculateNonListDefaultValueUseCase calculateDefaultValueUseCase;
  final FetchListValuesUseCase fetchListValuesUseCase;
  final UnitGroupRepository unitGroupRepository;

  const CalculateParamValueUseValue({
    required this.calculateDefaultValueUseCase,
    required this.fetchListValuesUseCase,
    required this.unitGroupRepository,
  });

  @override
  Future<Either<ConvertouchException, ConversionParamValueModel>> execute(
      InputParamValueCalculationModel input) async {
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

    ValueModel? calculatedBySrcValue;

    if (delta == null && paramValue.calculated) {
      calculatedBySrcValue = input.srcUnitValue != null
          ? rules.calculateParamValueBySrcValue(
              srcUnitValue: input.srcUnitValue!,
              unitGroupName: input.unitGroupName,
              params: input.paramSetValue,
              param: paramValue.param,
            )
          : null;
    }

    if (paramValue.listType == null) {
      if (delta == null && paramValue.calculated) {
        newValue = null;
        newDefaultValue = calculatedBySrcValue;
      } else if (newDefaultValueForNewUnit != null) {
        newDefaultValue = newDefaultValueForNewUnit;
      } else {
        newDefaultValue = newDefaultValue ??
            ObjectUtils.tryGet(
              await calculateDefaultValueUseCase.execute(
                InputDefaultValueCalculationModel(
                  item: paramValue.param,
                  conversionGroupName: input.unitGroupName,
                  currentParamUnit: paramValue.unit,
                  replacingUnit: newUnit,
                ),
              ),
            );
      }

      final resultParamValue = paramValue.copyWith(
        unit: newUnit,
        value: Patchable(newValue, patchNull: true),
        defaultValue: Patchable(newDefaultValue, patchNull: true),
      );

      return Right(resultParamValue);
    } else {
      if (delta == null && paramValue.calculated) {
        newValue = calculatedBySrcValue;
      }

      ListValuesFetchResult listValuesFetchResult = ObjectUtils.tryGet(
        await fetchListValuesUseCase.execute(
          InputItemsFetchModel(
            pageSize: listValuesPageSize,
            pageNum: 0,
            fetchParams: ListValuesFetchParams(
              itemId: paramValue.id,
              listType: paramValue.listType!,
              selectedValue: newValue,
              unit: newUnit,
              conversionGroupName: input.unitGroupName,
              params: input.paramSetValue,
            ),
          ),
        ),
      );

      return Right(
        paramValue.copyWith(
          value: Patchable(listValuesFetchResult.selectedItem, patchNull: true),
          unit: newUnit,
          listValuesFetchResult: Patchable(listValuesFetchResult),
        ),
      );
    }
  }
}
