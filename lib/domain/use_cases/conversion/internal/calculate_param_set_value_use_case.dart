import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_item_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_param_value_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class CalculateParamSetValueUseCase extends UseCase<
    InputParamSetValueCalculationModel, ConversionParamSetValueModel> {
  final CalculateParamValueUseValue calculateParamValueUseValue;

  const CalculateParamSetValueUseCase({
    required this.calculateParamValueUseValue,
  });

  @override
  Future<Either<ConvertouchException, ConversionParamSetValueModel>> execute(
    InputParamSetValueCalculationModel input,
  ) async {
    if (input.paramSetValue.paramValues.isEmpty) {
      return Right(input.paramSetValue);
    }

    ConversionParamSetValueModel newParamSetValue = input.paramSetValue;
    ConversionSingleParamModifyDelta? delta = input.delta;

    if (delta == null &&
        input.enableFirstCalculableParamIfNoCalculatedEnabled) {
      newParamSetValue = await newParamSetValue.copyWithChangedParams(
        changeFirstMatchedParamOnly: true,
        paramFilter: (paramValue) => paramValue.param.calculable,
        map: (paramValue, paramSetValue) async => paramValue.copyWith(
          calculated: true,
        ),
      );
    }

    int startParamId =
        delta?.paramId ?? newParamSetValue.paramValues.first.param.id;
    var startParamValue = newParamSetValue.getParamValueById(startParamId);

    if (startParamValue == null) {
      return Right(newParamSetValue);
    }

    OutputParamValueCalculationModel changedStartParam = ObjectUtils.tryGet(
      await calculateParamValueUseValue.execute(
        InputParamValueCalculationModel(
          itemValue: startParamValue,
          paramSetValue: newParamSetValue,
          delta: delta,
          srcUnitValue: input.srcUnitValue,
          unitGroupName: input.unitGroupName,
          alignCurrentValue: input.alignCurrentValues,
          fetchListValues:
              input.fetchListValues && delta is! EditConversionParamValueDelta,
          keepSelectedValueIfNotInList: input.keepSelectedValuesIfNotInList,
          onItemValueUpdated: input.onParamValueUpdated,
        ),
      ),
    );

    ConversionParamValueModel changedStartParamValue =
        await changedStartParam.result();

    newParamSetValue = await newParamSetValue.copyWithChangedParamById(
      paramId: startParamValue.param.id,
      map: (paramValue, paramSetValue) async => changedStartParamValue,
    );

    if (delta == null || delta is EditConversionParamValueDelta) {
      newParamSetValue = await _recalculateOtherParams(
        paramSetValue: newParamSetValue,
        paramId: changedStartParamValue.param.id,
        srcUnitValue: input.srcUnitValue,
        unitGroupName: input.unitGroupName,
        alignCurrentValues: input.alignCurrentValues,
        keepSelectedValuesIfNotInList: input.keepSelectedValuesIfNotInList,
        onParamValueUpdated: input.onParamValueUpdated,
        fetchListValues: input.fetchListValues,
      );
    }

    return Right(newParamSetValue);
  }

  Future<ConversionParamSetValueModel> _recalculateOtherParams({
    required ConversionParamSetValueModel paramSetValue,
    required int paramId,
    ConversionUnitValueModel? srcUnitValue,
    required String unitGroupName,
    required bool alignCurrentValues,
    required bool fetchListValues,
    required bool keepSelectedValuesIfNotInList,
    void Function(ConversionParamValueModel)? onParamValueUpdated,
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

      OutputParamValueCalculationModel modifiedParam = ObjectUtils.tryGet(
        await calculateParamValueUseValue.execute(
          InputParamValueCalculationModel(
            itemValue: paramValue,
            paramSetValue: modifiedParamSetValue,
            srcUnitValue: srcUnitValue,
            unitGroupName: unitGroupName,
            alignCurrentValue: alignCurrentValues,
            fetchListValues: fetchListValues,
            keepSelectedValueIfNotInList: keepSelectedValuesIfNotInList,
            onItemValueUpdated: onParamValueUpdated,
          ),
        ),
      );

      ConversionParamValueModel modifiedParamValue =
          await modifiedParam.result();

      modifiedParamSetValue =
          await modifiedParamSetValue.copyWithChangedParamById(
        paramId: paramValue.param.id,
        map: (paramValue, paramSetValue) async => modifiedParamValue,
      );
    }

    return modifiedParamSetValue;
  }
}
