import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateParamSetValueUseValue extends UseCase<
    InputParamSetValueCalculationModel, ConversionParamSetValueModel> {
  final CalculateParamValueUseValue calculateParamValueUseValue;

  const CalculateParamSetValueUseValue({
    required this.calculateParamValueUseValue,
  });

  @override
  Future<Either<ConvertouchException, ConversionParamSetValueModel>> execute(
    InputParamSetValueCalculationModel input,
  ) async {
    if (input.paramSetValue.paramValues.isEmpty) {
      return Right(input.paramSetValue);
    }

    ConversionSingleParamModifyDelta? delta = input.delta;

    int paramId =
        delta?.paramId ?? input.paramSetValue.paramValues.first.param.id;
    var paramValue = input.paramSetValue.getParamValueById(paramId);

    if (paramValue == null) {
      return Right(input.paramSetValue);
    }

    ConversionParamValueModel newParamValue = ObjectUtils.tryGet(
      await calculateParamValueUseValue.execute(
        InputParamValueCalculationModel(
          paramValue: paramValue,
          paramSetValue: input.paramSetValue,
          delta: delta,
          srcUnitValue: input.srcUnitValue,
          unitGroupName: input.unitGroupName,
          alignCurrentValue: input.alignCurrentValues,
        ),
      ),
    );

    var newParamSetValue = await input.paramSetValue.copyWithChangedParamById(
      paramId: paramId,
      map: (paramValue, paramSetValue) async => newParamValue,
    );

    if (delta == null || delta is EditConversionParamValueDelta) {
      return Right(
        await _recalculateOtherParams(
          paramSetValue: newParamSetValue,
          paramId: paramId,
          srcUnitValue: input.srcUnitValue,
          unitGroupName: input.unitGroupName,
          alignCurrentValues: input.alignCurrentValues,
        ),
      );
    } else {
      return Right(newParamSetValue);
    }
  }

  Future<ConversionParamSetValueModel> _recalculateOtherParams({
    required ConversionParamSetValueModel paramSetValue,
    required int paramId,
    ConversionUnitValueModel? srcUnitValue,
    String? unitGroupName,
    required bool alignCurrentValues,
  }) async {
    int indexByParamId =
        paramSetValue.paramValues.indexWhere((e) => e.param.id == paramId);

    if (indexByParamId < 0) {
      return paramSetValue;
    }

    var modifiedParamSetValue = paramSetValue;

    for (final (index, paramValue)
        in modifiedParamSetValue.paramValues.indexed) {
      if (index <= indexByParamId) {
        continue;
      }

      final modifiedParamValue = ObjectUtils.tryGet(
        await calculateParamValueUseValue.execute(
          InputParamValueCalculationModel(
            paramValue: paramValue,
            paramSetValue: modifiedParamSetValue,
            srcUnitValue: srcUnitValue,
            unitGroupName: unitGroupName,
            alignCurrentValue: alignCurrentValues,
          ),
        ),
      );

      modifiedParamSetValue =
          await modifiedParamSetValue.copyWithChangedParamById(
        paramId: paramValue.param.id,
        map: (paramValue, paramSetValue) async => modifiedParamValue,
      );
    }

    return modifiedParamSetValue;
  }
}
