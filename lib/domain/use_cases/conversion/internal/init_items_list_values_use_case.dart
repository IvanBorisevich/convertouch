import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_list_values_init_model.dart';
import 'package:convertouch/domain/use_cases/common/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class InitItemsListValuesUseCase
    extends UseCase<ConversionModel, ConversionModel> {
  final InitUnitListValuesUseCase initUnitListValuesUseCase;
  final InitParamListValuesUseCase initParamListValuesUseCase;

  const InitItemsListValuesUseCase({
    required this.initUnitListValuesUseCase,
    required this.initParamListValuesUseCase,
  });

  @override
  Future<Either<ConvertouchException, ConversionModel>> execute(
    ConversionModel input,
  ) async {
    try {
      List<ConversionUnitValueModel> enrichedUnitValues =
          await _enrichUnitValues(input.convertedUnitValues);

      final enrichedParamValues = await input.params?.copyWithChangedParams(
        paramFilter: (p) {
          return p.listType != null &&
              (p.listValues == null || p.listValues!.items.isEmpty);
        },
        map: (paramValue, paramSetValue) async {
          return ObjectUtils.tryGet(
            await initParamListValuesUseCase.execute(
              InputParamListValuesInitModel(
                paramValue: paramValue,
                paramSetValue: paramSetValue,
              ),
            ),
          );
        },
        changeFirstMatchedParamSetOnly: false,
        changeFirstMatchedParamOnly: false,
      );

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

      enrichedUnitValues.add(
        ObjectUtils.tryGet(await initUnitListValuesUseCase.execute(unitValue)),
      );
    }

    return enrichedUnitValues;
  }
}
