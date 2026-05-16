import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class InitItemsListValuesUseCase
    extends UseCase<ConversionModel, ConversionModel> {
  final FetchListValuesUseCase fetchListValuesUseCase;

  const InitItemsListValuesUseCase({
    required this.fetchListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> execute(
    ConversionModel input,
  ) async {
    try {
      List<ConversionUnitValueModel> enrichedUnitValues =
          await _enrichUnitValues(input.convertedUnitValues);

      ConversionParamSetValueBulkModel? enrichedParamValues =
          await _enrichParamValues(input.params);

      return Right(
        input.copyWith(
          convertedUnitValues: enrichedUnitValues,
          params: enrichedParamValues,
        ),
      );
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when enriching items with list values",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  Future<List<ConversionUnitValueModel>> _enrichUnitValues(
    List<ConversionUnitValueModel> unitValues,
  ) async {
    List<ConversionUnitValueModel> enrichedUnitValues = [];

    for (var unitValue in unitValues) {
      if (unitValue.listType == null ||
          unitValue.listValues != null &&
              unitValue.listValues!.items.isNotEmpty) {
        enrichedUnitValues.add(unitValue);
        continue;
      }

      var listValues = await _fetchFirstBatch(
        fetchParams: ListValuesFetchParams(
          listType: unitValue.listType!,
          unit: unitValue.unit,
        ),
      );

      enrichedUnitValues.add(
        unitValue.copyWith(
          listValues: listValues,
        ),
      );
    }

    return enrichedUnitValues;
  }

  Future<ConversionParamSetValueBulkModel?> _enrichParamValues(
    ConversionParamSetValueBulkModel? params,
  ) async {
    return await params?.copyWithChangedParams(
      paramFilter: (p) {
        return p.listType != null &&
            (p.listValues == null || p.listValues!.items.isEmpty);
      },
      map: (paramValue, paramSetValue) async {
        var listValues = await _fetchFirstBatch(
          fetchParams: ListValuesFetchParams(
            listType: paramValue.listType!,
            unit: paramValue.unit,
            params: paramSetValue,
          ),
        );

        return paramValue.copyWith(
          listValues: listValues,
        );
      },
      changeFirstMatchedParamSetOnly: false,
      changeFirstMatchedParamOnly: false,
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
          params: fetchParams,
        ),
      ),
    );
  }
}
