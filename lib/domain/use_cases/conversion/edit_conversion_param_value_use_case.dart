import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class EditConversionParamValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionParamValueDelta> {
  const EditConversionParamValueUseCase({
    required super.createConversionUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> modifyConversionParamValues({
    required ConversionParamSetValueBulkModel? currentParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? currentSourceItem,
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

    ConversionParamValueModel paramValue = paramValues[paramValueIndex];

    ValueModel newValue = ValueModel.str(delta.newValue);
    ValueModel newDefaultValue = delta.newDefaultValue != null
        ? ValueModel.str(delta.newDefaultValue)
        : ValueModel.one;

    paramValues[paramValueIndex] = paramValue.copyWith(
      value: newValue,
      defaultValue: newDefaultValue,
    );

    paramSetValues[paramSetValueIndex] = paramSetValue.copyWith(
      paramValues: paramValues,
    );

    return currentParams.copyWith(
      paramSetValues: paramSetValues,
    );
  }
}
