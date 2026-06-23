import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_list_values_init_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class _InitItemListValuesUseCase<M extends ItemValueModel,
    I extends InputItemListValuesInitModel<M>> extends UseCase<I, M> {
  final FetchListValuesUseCase fetchListValuesUseCase;

  const _InitItemListValuesUseCase({
    required this.fetchListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, M>> execute(I input) async {
    if (input.itemValue.listType == null) {
      return Right(input.itemValue);
    }

    bool needToFetch = !input.itemValue.listType!.cached ||
        !input.itemValue.listType!.fetchedViaApi || !input.autoFetch;

    bool asyncFetch = input.itemValue.listType!.fetchedViaApi;

    M resultValue;

    if (needToFetch) {
      final fetchFirstBatchFuture = _fetchFirstBatch(input);

      if (asyncFetch) {
        resultValue = _buildItemValue(
          input: input,
          listValuesFetchResult: const OutputItemsFetchModel.loading(),
        );

        input.onListValuesFetched?.call(resultValue);

        fetchFirstBatchFuture.then((fetchResult) {
          final listValuesFetchResult = ObjectUtils.tryGet(fetchResult);

          log("After async fetch first batch of list values: "
              "$listValuesFetchResult");

          M itemValue = _buildItemValue(
            input: input,
            listValuesFetchResult: listValuesFetchResult,
          );

          input.onListValuesFetched?.call(itemValue);
        });
      } else {
        log("Sync fetch first batch of list values");

        resultValue = _buildItemValue(
          input: input,
          listValuesFetchResult:
              ObjectUtils.tryGet(await fetchFirstBatchFuture),
        );

        input.onListValuesFetched?.call(resultValue);
      }
    } else {
      log("No need to fetch list values");

      resultValue = _buildItemValue(
        input: input,
        listValuesFetchResult: input.itemValue.listValuesFetchResult!,
      );

      input.onListValuesFetched?.call(resultValue);
    }

    return Right(resultValue);
  }

  Future<Either<ConvertouchException, ListValuesFetchResult>> _fetchFirstBatch(
    I input,
  ) {
    return fetchListValuesUseCase.execute(
      InputItemsFetchModel(
        pageSize: listValuesPageSize,
        pageNum: 0,
        fetchParams: ListValuesFetchParams(
          itemId: input.itemValue.id,
          listType: input.itemValue.listType!,
          unit: input.itemValue.unitItem,
          params: input.paramSetValue,
          selectedValue: input.itemValue.value,
        ),
      ),
    );
  }

  M _buildItemValue({
    required I input,
    required ListValuesFetchResult listValuesFetchResult,
  }) {
    return input.itemValue.copyWith(
      value: input.alignSelectedValue
          ? _alignCurrentValue(input, listValuesFetchResult)
          : input.itemValue.value,
      defaultValue: ValueModel.empty,
      listValuesFetchResult: listValuesFetchResult,
    ) as M;
  }

  ValueModel? _alignCurrentValue(
    I input,
    ListValuesFetchResult fetchResult,
  ) {
    if (fetchResult.status == FetchingStatus.failure) {
      return input.itemValue.value;
    }

    if (input.itemValue.value != null) {
      if (fetchResult.containsSelectedValue) {
        return input.itemValue.value;
      } else if (input.keepSelectedValueIfNotInList) {
        return input.itemValue.value;
      }
    } else if (input.keepSelectedValueIfNotInList) {
      return null;
    }

    return input.itemValue.listType!.preselected
        ? fetchResult.items.firstOrNull
        : null;
  }
}

class InitUnitListValuesUseCase extends _InitItemListValuesUseCase<
    ConversionUnitValueModel, InputUnitListValuesInitModel> {
  const InitUnitListValuesUseCase({
    required super.fetchListValuesUseCase,
  });
}

class InitParamListValuesUseCase extends _InitItemListValuesUseCase<
    ConversionParamValueModel, InputParamListValuesInitModel> {
  const InitParamListValuesUseCase({
    required super.fetchListValuesUseCase,
  });
}
