import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_value_calculation_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_param_set_value_calculation_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/calculate_item_value_use_case.dart';
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
    ConversionParamsModifyDelta? delta = input.delta;

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
        input.startParamId ?? newParamSetValue.paramValues.first.param.id;
    var startParamValue = newParamSetValue.getParamValueById(startParamId);

    if (startParamValue == null) {
      return Right(newParamSetValue);
    }

    ConversionParamValueModel changedStartParamValue = ObjectUtils.tryGet(
      await calculateParamValueUseValue.execute(
        InputParamValueCalculationModel(
          itemValue: startParamValue,
          paramSetValue: newParamSetValue,
          delta: delta,
          srcUnitValue: input.srcUnitValue,
          conversionGroup: input.conversionGroup,
        ),
      ),
    );

    newParamSetValue = await newParamSetValue.copyWithChangedParamById(
      paramId: startParamValue.param.id,
      map: (paramValue, paramSetValue) async => changedStartParamValue,
    );

    if (delta == null || delta is EditConversionParamValueDelta) {
      newParamSetValue = await _recalculateOtherParams(
        paramSetValue: newParamSetValue,
        paramId: changedStartParamValue.param.id,
        srcUnitValue: input.srcUnitValue,
        conversionGroup: input.conversionGroup,
        onParamValueUpdated: input.onParamValueUpdated,
      );
    }

    return Right(newParamSetValue);
  }

  Future<ConversionParamSetValueModel> _recalculateOtherParams({
    required ConversionParamSetValueModel paramSetValue,
    required int paramId,
    ConversionUnitValueModel? srcUnitValue,
    required UnitGroupModel conversionGroup,
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

      ConversionParamValueModel modifiedParamValue = ObjectUtils.tryGet(
        await calculateParamValueUseValue.execute(
          InputParamValueCalculationModel(
            itemValue: paramValue,
            paramSetValue: modifiedParamSetValue,
            srcUnitValue: srcUnitValue,
            conversionGroup: conversionGroup,
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
