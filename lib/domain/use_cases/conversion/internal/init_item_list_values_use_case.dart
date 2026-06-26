import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_list_values_init_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class _InitItemListValuesUseCase<
    M extends ItemValueModel,
    I extends InputItemListValuesInitModel<M>,
    O extends OutputItemValueCalculationModel<M>> extends UseCase<I, O> {
  final FetchListValuesUseCase fetchListValuesUseCase;

  const _InitItemListValuesUseCase({
    required this.fetchListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, O>> execute(I input) async {
    if (input.itemValue.listType == null) {
      return Right(
        buildOutput(itemValue: input.itemValue),
      );
    }

    log("Check params before fetching list values: "
        "\nlistType = ${input.itemValue.listType}, "
        "\ncached = ${input.itemValue.listType!.cached}, "
        "\nfetchListValues = ${input.fetchListValues}, "
        "\nlistValuesFetchResult = ${input.itemValue.listValuesFetchResult}, "
        "\nfetchedViaApi = ${input.itemValue.listType!.fetchedViaApi}");

    bool needToFetch = input.fetchListValues &&
        (!input.itemValue.listType!.cached ||
            input.itemValue.listValuesFetchResult == null ||
            !input.itemValue.listValuesFetchResult!.hasReachedMax ||
            input.itemValue.listType!.fetchedViaApi);

    bool asyncFetch = input.itemValue.listType!.fetchedViaApi;

    if (needToFetch) {
      final listValuesFetchFuture = _fetchFirstBatch(input);

      if (asyncFetch) {
        log("${DateTime.now()} - Async fetch future creation started, list type: ${input.itemValue.listType}");

        M resultValue = _buildItemValue(
          input: input,
          listValuesFetchResult: const OutputItemsFetchModel.loading(),
        );

        input.onListValuesFetched?.call(resultValue);

        ItemValueFuture<M>? itemValueFuture = listValuesFetchFuture.then(
          (fetchResult) {
            final listValuesFetchResult = ObjectUtils.tryGet(fetchResult);

            log("${DateTime.now()} - After async fetch first batch of list values: "
                "$listValuesFetchResult");

            M itemValue = _buildItemValue(
              input: input,
              listValuesFetchResult: listValuesFetchResult,
            );

            input.onListValuesFetched?.call(itemValue);

            return Right(itemValue);
          },
        );

        log("${DateTime.now()} - Async fetch future created, list type: ${input.itemValue.listType}");

        return Right(
          buildOutput(
            itemValue: resultValue,
            itemValueFuture: itemValueFuture,
          ),
        );
      } else {
        log("${DateTime.now()} - Sync fetch first batch of list values, list type: "
            "${input.itemValue.listType}");

        M resultValue = _buildItemValue(
          input: input,
          listValuesFetchResult:
              ObjectUtils.tryGet(await listValuesFetchFuture),
        );

        input.onListValuesFetched?.call(resultValue);

        return Right(
          buildOutput(itemValue: resultValue),
        );
      }
    }

    log("${DateTime.now()} - No need to fetch list values, list type: "
        "${input.itemValue.listType}");

    M resultValue = _buildItemValue(
      input: input,
      listValuesFetchResult: input.itemValue.listValuesFetchResult,
    );

    input.onListValuesFetched?.call(resultValue);

    return Right(
      buildOutput(itemValue: resultValue),
    );
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
    required ListValuesFetchResult? listValuesFetchResult,
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
    ListValuesFetchResult? fetchResult,
  ) {
    if (fetchResult == null) {
      return input.keepSelectedValueIfNotInList ? input.itemValue.value : null;
    }

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

  O buildOutput({
    required M itemValue,
    ItemValueFuture<M>? itemValueFuture,
  });
}

class InitUnitListValuesUseCase extends _InitItemListValuesUseCase<
    ConversionUnitValueModel,
    InputUnitListValuesInitModel,
    OutputUnitValueCalculationModel> {
  const InitUnitListValuesUseCase({
    required super.fetchListValuesUseCase,
  });

  @override
  OutputUnitValueCalculationModel buildOutput({
    required ConversionUnitValueModel itemValue,
    ItemValueFuture<ConversionUnitValueModel>? itemValueFuture,
  }) {
    return OutputUnitValueCalculationModel(
      itemValue: itemValue,
      itemValueFuture: itemValueFuture,
    );
  }
}

class InitParamListValuesUseCase extends _InitItemListValuesUseCase<
    ConversionParamValueModel,
    InputParamListValuesInitModel,
    OutputParamValueCalculationModel> {
  const InitParamListValuesUseCase({
    required super.fetchListValuesUseCase,
  });

  @override
  OutputParamValueCalculationModel buildOutput({
    required ConversionParamValueModel itemValue,
    ItemValueFuture<ConversionParamValueModel>? itemValueFuture,
  }) {
    return OutputParamValueCalculationModel(
      itemValue: itemValue,
      itemValueFuture: itemValueFuture,
    );
  }
}
