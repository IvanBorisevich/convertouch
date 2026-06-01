import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_list_values_init_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class InitItemListValuesUseCase<M extends ConversionItemValueModel,
    I extends InputItemListValuesInitModel<M>> extends UseCase<I, M> {
  final FetchListValuesUseCase fetchListValuesUseCase;

  const InitItemListValuesUseCase({
    required this.fetchListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, M>> execute(I input) async {
    if (input.itemValue.listType == null) {
      return Right(input.itemValue);
    }

    var listValuesBatch = await _fetchFirstBatch(
      fetchParams: ListValuesFetchParams(
        listType: input.itemValue.listType!,
        unit: input.itemValue.unitItem,
        params: input.paramSetValue,
        selectedValue: input.itemValue.value,
      ),
    );

    return Right(
      input.itemValue.copyWith(
        value: input.alignSelectedValue
            ? await _alignCurrentValue(input, listValuesBatch)
            : input.itemValue.value,
        listValues: listValuesBatch,
      ) as M,
    );
  }

  Future<ValueModel?> _alignCurrentValue(
      I input, OutputListValuesBatch batch) async {
    if (input.itemValue.value == null && input.alignForNull) {
      return null;
    }

    if (input.itemValue.value != null && batch.containsSelectedValue) {
      return input.itemValue.value;
    }

    return _getDefaultListValue(
      listValuesBatch: batch,
      preselected: input.itemValue.listType!.preselected,
    );
  }

  Future<OutputListValuesBatch> _fetchFirstBatch({
    required ListValuesFetchParams fetchParams,
  }) async {
    return ObjectUtils.tryGet(
      await fetchListValuesUseCase.execute(
        InputItemsFetchModel(
          pageSize: listValuesPageSize,
          pageNum: 0,
          fetchParams: fetchParams,
        ),
      ),
    );
  }

  ValueModel? _getDefaultListValue({
    required OutputListValuesBatch listValuesBatch,
    required bool preselected,
  }) {
    return preselected ? listValuesBatch.items.firstOrNull : null;
  }
}

class InitUnitListValuesUseCase extends InitItemListValuesUseCase<
    ConversionUnitValueModel, InputUnitListValuesInitModel> {
  const InitUnitListValuesUseCase({
    required super.fetchListValuesUseCase,
  });
}

class InitParamListValuesUseCase extends InitItemListValuesUseCase<
    ConversionParamValueModel, InputParamListValuesInitModel> {
  const InitParamListValuesUseCase({
    required super.fetchListValuesUseCase,
  });
}
