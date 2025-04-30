import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class ReplaceConversionParamUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionParamUnitDelta> {
  const ReplaceConversionParamUnitUseCase({
    required super.convertUnitValuesUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required ReplaceConversionParamUnitDelta delta,
  }) async {
    if (oldConversionParams == null || oldConversionParams.paramSetValues.isEmpty) {
      return oldConversionParams;
    }

    List<ConversionParamSetValueModel> paramSetValues = [
      ...oldConversionParams.paramSetValues
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

    paramValues[paramValueIndex] = paramValue.copyWith(
      unit: delta.newUnit,
    );

    paramSetValues[paramSetValueIndex] = paramSetValue.copyWith(
      paramValues: paramValues,
    );

    return oldConversionParams.copyWith(
      paramSetValues: paramSetValues,
    );
  }
}
