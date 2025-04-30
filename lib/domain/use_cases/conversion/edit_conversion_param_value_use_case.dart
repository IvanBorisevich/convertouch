import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class EditConversionParamValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionParamValueDelta> {
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const EditConversionParamValueUseCase({
    required super.convertUnitValuesUseCase,
    required this.calculateDefaultValueUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required EditConversionParamValueDelta delta,
  }) async {
    if (oldConversionParams == null || oldConversionParams.paramSetValues.isEmpty) {
      return oldConversionParams;
    }

    List<ConversionParamSetValueModel> paramSetValues = [
      ...oldConversionParams.paramSetValues
    ];

    int paramSetValueIndex = paramSetValues.indexWhere(
      (p) => p.paramSet.id == delta.paramSetId,
    );

    ConversionParamSetValueModel paramSetValue =
        paramSetValues[paramSetValueIndex];

    List<ConversionParamValueModel> paramValues = [
      ...paramSetValue.paramValues
    ];

    int paramValueIndex = paramValues.indexWhere(
      (p) => p.param.id == delta.paramId,
    );

    ConversionParamValueModel newParamValue = paramValues[paramValueIndex];

    if (newParamValue.listType != null) {
      newParamValue = ConversionParamValueModel(
        param: newParamValue.param,
        unit: newParamValue.unit,
        calculated: newParamValue.calculated,
        value: ValueModel.any(delta.newValue),
      );
    } else {
      ValueModel? defaultValue = ValueModel.any(delta.newDefaultValue) ??
          ObjectUtils.tryGet(
            await calculateDefaultValueUseCase.execute(newParamValue.unit!),
          );

      newParamValue = ConversionParamValueModel(
        param: newParamValue.param,
        unit: newParamValue.unit,
        calculated: newParamValue.calculated,
        value: ValueModel.any(delta.newValue),
        defaultValue: defaultValue,
      );
    }

    paramValues[paramValueIndex] = newParamValue;

    paramSetValues[paramSetValueIndex] = paramSetValue.copyWith(
      paramValues: paramValues,
    );

    return oldConversionParams.copyWith(
      paramSetValues: paramSetValues,
    );
  }
}
