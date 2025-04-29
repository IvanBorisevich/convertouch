import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class EditConversionParamValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionParamValueDelta> {
  const EditConversionParamValueUseCase({
    required super.convertUnitValuesUseCase,
    required super.calculateDefaultValueUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> modifyConversionParamValues({
    required ConversionParamSetValueBulkModel? currentParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required EditConversionParamValueDelta delta,
  }) async {
    if (currentParams == null || currentParams.paramSetValues.isEmpty) {
      return currentParams;
    }

    List<ConversionParamSetValueModel> paramSetValues = [
      ...currentParams.paramSetValues
    ];

    int paramSetValueIndex =
        paramSetValues.indexWhere((p) => p.paramSet.id == delta.paramSetId);

    ConversionParamSetValueModel paramSetValue =
        paramSetValues[paramSetValueIndex];

    List<ConversionParamValueModel> paramValues = [
      ...paramSetValue.paramValues
    ];

    int paramValueIndex =
        paramValues.indexWhere((p) => p.param.id == delta.paramId);

    paramValues[paramValueIndex] = ConversionParamValueModel(
      param: paramValues[paramValueIndex].param,
      unit: paramValues[paramValueIndex].unit,
      calculated: paramValues[paramValueIndex].calculated,
      value: ValueModel.any(delta.newValue),
      defaultValue: ValueModel.any(delta.newDefaultValue),
    );

    paramSetValues[paramSetValueIndex] = paramSetValue.copyWith(
      paramValues: paramValues,
    );

    return currentParams.copyWith(
      paramSetValues: paramSetValues,
    );
  }
}
