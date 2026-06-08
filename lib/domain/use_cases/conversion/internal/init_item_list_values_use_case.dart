import 'package:convertouch/domain/constants/constants.dart';
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

    ListValuesFetchResult listValuesFetchResult;

    if (input.itemValue.listValuesFetchResult != null &&
        input.itemValue.listValuesFetchResult!.hasReachedMax &&
        input.itemValue.listType!.fetchOnce) {
      listValuesFetchResult = input.itemValue.listValuesFetchResult!;
    } else {
      listValuesFetchResult = await _fetchFirstBatch(
        fetchParams: ListValuesFetchParams(
          itemId: input.itemValue.itemId,
          listType: input.itemValue.listType!,
          unit: input.itemValue.unitItem,
          params: input.paramSetValue,
          selectedValue: input.itemValue.value,
        ),
      );
    }

    return Right(
      input.itemValue.copyWith(
        value: input.alignSelectedValue
            ? await _alignCurrentValue(input, listValuesFetchResult)
            : input.itemValue.value,
        defaultValue: ValueModel.empty,
        listValuesFetchResult: listValuesFetchResult,
      ) as M,
    );
  }

  Future<ValueModel?> _alignCurrentValue(
    I input,
    ListValuesFetchResult fetchResult,
  ) async {
    if (fetchResult.status == FetchingStatus.failure) {
      return input.itemValue.value;
    }

    if (input.itemValue.value == null && input.alignForNull) {
      return null;
    }

    if (input.itemValue.value != null && fetchResult.containsSelectedValue) {
      return input.itemValue.value;
    }

    return _getDefaultListValue(
      listValuesFetchResult: fetchResult,
      preselected: input.itemValue.listType!.preselected,
    );
  }

  Future<ListValuesFetchResult> _fetchFirstBatch({
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
    required ListValuesFetchResult listValuesFetchResult,
    required bool preselected,
  }) {
    return preselected ? listValuesFetchResult.items.firstOrNull : null;
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
