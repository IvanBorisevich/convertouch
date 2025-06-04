import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_items_fetch_model.dart';
import 'package:convertouch/domain/use_cases/list_values/fetch_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class EnrichItemsWithListValuesUseCase
    extends UseCase<ConversionModel, ConversionModel> {
  final FetchListValuesUseCase fetchListValuesUseCase;

  const EnrichItemsWithListValuesUseCase({
    required this.fetchListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> execute(
    ConversionModel input,
  ) async {
    try {
      List<ConversionUnitValueModel> enrichedUnitValues = [];

      for (var conversionUnitValue in input.convertedUnitValues) {
        if (conversionUnitValue.listType == null ||
            conversionUnitValue.listValues != null &&
                conversionUnitValue.listValues!.items.isNotEmpty) {
          enrichedUnitValues.add(conversionUnitValue);
          continue;
        }

        var listValues = await _fetchListValues(
          listType: conversionUnitValue.listType!,
          unit: conversionUnitValue.unit,
        );

        enrichedUnitValues.add(
          conversionUnitValue.copyWith(
            listValues: listValues,
          ),
        );
      }

      var newParams = await input.params?.copyWithChangedParams(
        paramFilter: (p) {
          return p.listType != null &&
              (p.listValues == null || p.listValues!.items.isEmpty);
        },
        map: (paramValue, paramSetValue) async {
          var listValues = await _fetchListValues(
            listType: paramValue.listType!,
            unit: paramValue.unit,
          );

          return paramValue.copyWith(
            listValues: listValues,

          );
        },
        changeFirstParamOnly: false,
      );

      return Right(
        input.copyWith(
          convertedUnitValues: enrichedUnitValues,
          params: newParams,
        ),
      );
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when enriching items with list values",
          stackTrace: null,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  Future<OutputListValuesBatch> _fetchListValues({
    required ConvertouchListType listType,
    UnitModel? unit,
  }) async {
    return ObjectUtils.tryGet(
      await fetchListValuesUseCase.execute(
        InputItemsFetchModel(
          pageSize: 100,
          pageNum: 0,
          params: ListValuesFetchParams(
            listType: listType,
            unit: unit,
          ),
        ),
      ),
    );
  }
}
