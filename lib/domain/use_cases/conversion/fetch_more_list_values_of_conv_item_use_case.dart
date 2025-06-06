import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class FetchMoreListValuesOfConvItemUseCase
    extends AbstractModifyConversionUseCase<
        FetchMoreListValuesOfConversionItemDelta> {
  final FetchListValuesUseCase fetchListValuesUseCase;

  const FetchMoreListValuesOfConvItemUseCase({
    required this.fetchListValuesUseCase,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required UnitGroupModel unitGroup,
    required ConversionParamSetValueModel? params,
    required FetchMoreListValuesOfConversionItemDelta delta,
  }) async {
    ConversionUnitValueModel unitValue = oldConvertedUnitValues[delta.unitId]!;

    if (unitValue.listValues != null) {
      OutputListValuesBatch currentBatch = unitValue.listValues!;

      OutputListValuesBatch newBatch = ObjectUtils.tryGet(
        await fetchListValuesUseCase.execute(
          InputItemsFetchModel(
            searchString: currentBatch.searchString,
            pageSize: listValuesPageSize,
            pageNum: currentBatch.pageNum,
            params: currentBatch.params,
          ),
        ),
      );

      unitValue = unitValue.copyWith(
        listValues: newBatch.copyWith(
          items: [
            ...currentBatch.items,
            ...newBatch.items,
          ],
          hasReachedMax: newBatch.hasReachedMax,
        ),
      );

      return oldConvertedUnitValues.map(
        (key, value) => key == delta.unitId
            ? MapEntry(key, unitValue)
            : MapEntry(key, value),
      );
    }

    return oldConvertedUnitValues;
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> newConvertedUnitValues,
    required FetchMoreListValuesOfConversionItemDelta delta,
  }) async {
    if (oldSourceUnitValue.unit.id == delta.unitId &&
        oldSourceUnitValue.listValues != null) {
      OutputListValuesBatch currentBatch = oldSourceUnitValue.listValues!;

      OutputListValuesBatch newBatch = ObjectUtils.tryGet(
        await fetchListValuesUseCase.execute(
          InputItemsFetchModel(
            searchString: currentBatch.searchString,
            pageSize: listValuesPageSize,
            pageNum: currentBatch.pageNum,
            params: currentBatch.params,
          ),
        ),
      );

      return oldSourceUnitValue.copyWith(
        listValues: newBatch.copyWith(
          items: [
            ...currentBatch.items,
            ...newBatch.items,
          ],
          hasReachedMax: newBatch.hasReachedMax,
        ),
      );
    }

    return oldSourceUnitValue;
  }
}
