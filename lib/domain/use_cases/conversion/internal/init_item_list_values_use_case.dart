import 'dart:async';
import 'dart:developer';

import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_list_values_init_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_list_value_validation_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_items_fetch_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/list_values/validate_list_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class _InitItemListValuesUseCase<
    M extends ItemValueModel,
    I extends InputItemListValuesInitModel<M>,
    O extends OutputItemValueCalculationModel<M>> extends UseCase<I, O> {
  final FetchListValuesUseCase fetchListValuesUseCase;
  final ValidateListValueUseCase validateListValueUseCase;

  const _InitItemListValuesUseCase({
    required this.fetchListValuesUseCase,
    required this.validateListValueUseCase,
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

    ListValuesFetchParams fetchParams = ListValuesFetchParams(
      itemId: input.itemValue.id,
      listType: input.itemValue.listType!,
      unit: input.itemValue.unitItem,
      params: input.paramSetValue,
    );

    if (needToFetch) {
      final listValuesFetchFuture = _fetchFirstBatch(fetchParams);

      if (asyncFetch) {
        log("${DateTime.now()} - Async fetch future creation started, "
            "list type: ${input.itemValue.listType}");

        M resultValue = _enrichItemValue(
          input.itemValue,
          listValuesFetchResult: const OutputItemsFetchModel.loading(),
        );

        input.onListValuesFetched?.call(resultValue);

        ItemValueFuture<M>? itemValueFuture = listValuesFetchFuture.then(
          (fetchResult) async {
            final listValuesFetchResult = ObjectUtils.tryGet(fetchResult);

            log("${DateTime.now()} - After async fetch first batch of list values");

            ValueModel? alignedValue = input.alignSelectedValue
                ? await _alignCurrentValue(
                    input.itemValue.value,
                    listValuesFetchResult.items,
                    fetchParams: fetchParams,
                    keepSelectedValueIfNotInList:
                        input.keepSelectedValueIfNotInList,
                    preselected: input.itemValue.listType!.preselected,
                  )
                : input.itemValue.value;

            M resultItemValue = _enrichItemValue(
              input.itemValue,
              value: alignedValue,
              listValuesFetchResult: listValuesFetchResult,
            );

            input.onListValuesFetched?.call(resultItemValue);

            return Right(resultItemValue);
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

        ListValuesFetchResult? listValuesFetchResult =
            ObjectUtils.tryGet(await listValuesFetchFuture);

        ValueModel? alignedValue = input.alignSelectedValue
            ? await _alignCurrentValue(
                input.itemValue.value,
                listValuesFetchResult?.items,
                fetchParams: fetchParams,
                keepSelectedValueIfNotInList:
                    input.keepSelectedValueIfNotInList,
                preselected: input.itemValue.listType!.preselected,
              )
            : input.itemValue.value;

        M resultItemValue = _enrichItemValue(
          input.itemValue,
          value: alignedValue,
          listValuesFetchResult: listValuesFetchResult,
        );

        input.onListValuesFetched?.call(resultItemValue);

        return Right(
          buildOutput(itemValue: resultItemValue),
        );
      }
    }

    log("${DateTime.now()} - No need to fetch list values, list type: "
        "${input.itemValue.listType}");

    ValueModel? alignedValue = input.alignSelectedValue
        ? await _alignCurrentValue(
            input.itemValue.value,
            input.itemValue.listValuesFetchResult?.items,
            fetchParams: fetchParams,
            keepSelectedValueIfNotInList: input.keepSelectedValueIfNotInList,
            preselected: input.itemValue.listType!.preselected,
          )
        : input.itemValue.value;

    M resultValue = _enrichItemValue(
      input.itemValue,
      value: alignedValue,
      listValuesFetchResult: input.itemValue.listValuesFetchResult,
    );

    input.onListValuesFetched?.call(resultValue);

    return Right(
      buildOutput(itemValue: resultValue),
    );
  }

  Future<Either<ConvertouchException, ListValuesFetchResult>> _fetchFirstBatch(
    ListValuesFetchParams fetchParams,
  ) {
    return fetchListValuesUseCase.execute(
      InputItemsFetchModel(
        pageSize: listValuesPageSize,
        pageNum: 0,
        fetchParams: fetchParams,
      ),
    );
  }

  Future<ValueModel?> _alignCurrentValue(
    ValueModel? value,
    List<ValueModel>? listValues, {
    required ListValuesFetchParams? fetchParams,
    required bool keepSelectedValueIfNotInList,
    required bool preselected,
  }) async {
    if (listValues == null || listValues.isEmpty) {
      return keepSelectedValueIfNotInList ? value : null;
    }

    ValueModel? foundSelectedValue = ObjectUtils.tryGet(
      await validateListValueUseCase.execute(
        InputListValueValidationModel(
          value: value,
          fetchParams: fetchParams,
        ),
      ),
    );

    if (foundSelectedValue != null) {
      return keepSelectedValueIfNotInList ? value : foundSelectedValue;
    } else if (keepSelectedValueIfNotInList) {
      return null;
    }

    return preselected ? listValues.firstOrNull : null;
  }

  M _enrichItemValue(
    M itemValue, {
    ValueModel? value,
    ListValuesFetchResult? listValuesFetchResult,
  }) {
    return itemValue.copyWith(
      value: Patchable(value, patchNull: true),
      listValuesFetchResult: Patchable(listValuesFetchResult, patchNull: true),
    ) as M;
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
    required super.validateListValueUseCase,
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
    required super.validateListValueUseCase,
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
