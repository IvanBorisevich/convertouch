import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class FetchMoreListValuesOfParamUseCase
    extends AbstractModifyConversionUseCase<FetchMoreListValuesOfParamDelta> {
  final FetchListValuesUseCase fetchListValuesUseCase;

  const FetchMoreListValuesOfParamUseCase({
    required this.fetchListValuesUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required FetchMoreListValuesOfParamDelta delta,
  }) async {
    return oldConversionParams?.copyWithChangedParams(
      changeFirstMatchedParamSetOnly: true,
      changeFirstMatchedParamOnly: true,
      paramFilter: (param) =>
          param.param.id == delta.paramId && param.listValues != null,
      map: (param, paramSet) async {
        OutputListValuesBatch currentBatch = param.listValues!;

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

        return param.copyWith(
          listValues: newBatch.copyWith(
            items: [
              ...currentBatch.items,
              ...newBatch.items,
            ],
            hasReachedMax: newBatch.hasReachedMax,
          ),
        );
      },
    );
  }
}
