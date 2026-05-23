import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_list_values_init_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

abstract class InitItemListValuesUseCase<I, O extends ConversionItemValueModel>
    extends UseCase<I, O> {
  final FetchListValuesUseCase fetchListValuesUseCase;

  const InitItemListValuesUseCase({
    required this.fetchListValuesUseCase,
  });

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
    return preselected ? listValuesBatch.items.firstOrNull?.valueModel : null;
  }
}

class InitUnitListValuesUseCase extends InitItemListValuesUseCase<
    ConversionUnitValueModel, ConversionUnitValueModel> {
  const InitUnitListValuesUseCase({
    required super.fetchListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionUnitValueModel>> execute(
    ConversionUnitValueModel input,
  ) async {
    if (input.listType == null) {
      return Right(input);
    }

    var listValuesBatch = await _fetchFirstBatch(
      fetchParams: ListValuesFetchParams(
        listType: input.listType!,
        unit: input.unit,
      ),
    );

    return Right(
      input.copyWith(
        value: listValuesBatch.containsSelectedValue == true
            ? input.value
            : _getDefaultListValue(
                listValuesBatch: listValuesBatch,
                preselected: input.listType!.preselected,
              ),
        listValues: listValuesBatch,
      ),
    );
  }
}

class InitParamListValuesUseCase extends InitItemListValuesUseCase<
    InputParamListValuesInitModel, ConversionParamValueModel> {
  const InitParamListValuesUseCase({
    required super.fetchListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionParamValueModel>> execute(
    InputParamListValuesInitModel input,
  ) async {
    if (input.paramValue.listType == null) {
      return Right(input.paramValue);
    }

    var listValuesBatch = await _fetchFirstBatch(
      fetchParams: ListValuesFetchParams(
          listType: input.paramValue.listType!,
          unit: input.paramValue.unit,
          params: input.paramSetValue,
          selectedValue: input.paramValue.value),
    );

    return Right(
      input.paramValue.copyWith(
        value: listValuesBatch.containsSelectedValue == true
            ? input.paramValue.value
            : _getDefaultListValue(
                listValuesBatch: listValuesBatch,
                preselected: input.paramValue.listType!.preselected,
              ),
        listValues: listValuesBatch,
      ),
    );
  }
}
