import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_list_values_init_model.dart';
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
      final recalculatedParams = await _recalculateParams(input.params);

      List<ConversionUnitValueModel> enrichedUnitValues =
          await _enrichUnitValues(
        unitValues: input.convertedUnitValues,
        params: recalculatedParams?.active,
      );

      return Right(
        input.copyWith(
          params: recalculatedParams,
          srcUnitValue: enrichedUnitValues.firstWhereOrNull(
            (unitValue) => unitValue.unit.id == input.srcUnitValue?.unit.id,
          ),
          convertedUnitValues: enrichedUnitValues,
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

  Future<ConversionParamSetValueBulkModel?> _recalculateParams(
    ConversionParamSetValueBulkModel? params,
  ) async {
    if (params == null) {
      return null;
    }

    ConversionParamSetValueModel? paramSetValueModel = params.active;

    if (paramSetValueModel == null) {
      return params;
    }

    for (var paramValue in paramSetValueModel.paramValues) {
      if (paramValue.listType == null) {
        continue;
      }

      final modifiedParamValue = ObjectUtils.tryGet(
        await initParamListValuesUseCase.execute(
          InputParamListValuesInitModel(
            itemValue: paramValue,
            paramSetValue: paramSetValueModel,
          ),
        ),
      );

      paramSetValueModel = await paramSetValueModel!.copyWithChangedParamById(
        paramId: paramValue.param.id,
        map: (paramValue, paramSetValue) async => modifiedParamValue,
      );
    }

    return await params.copyWithChangedParamSetById(
      paramSetId: paramSetValueModel!.paramSet.id,
      map: (paramSetValue) async => paramSetValueModel!,
    );
  }

  Future<List<ConversionUnitValueModel>> _enrichUnitValues({
    required List<ConversionUnitValueModel> unitValues,
    required ConversionParamSetValueModel? params,
  }) async {
    List<ConversionUnitValueModel> enrichedUnitValues = [];

    for (var unitValue in unitValues) {
      enrichedUnitValues.add(
        ObjectUtils.tryGet(
          await initUnitListValuesUseCase.execute(
            InputUnitListValuesInitModel(
              itemValue: unitValue,
              paramSetValue: params,
              alignSelectedValue: false,
            ),
          ),
        ),
      );
    }

    return enrichedUnitValues;
  }
}
