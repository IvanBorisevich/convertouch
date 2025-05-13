import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class ReplaceConversionParamUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionParamUnitDelta> {
  final ListValueRepository listValueRepository;
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const ReplaceConversionParamUnitUseCase({
    required super.convertUnitValuesUseCase,
    required this.calculateDefaultValueUseCase,
    required this.listValueRepository,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required ReplaceConversionParamUnitDelta delta,
  }) async {
    if (oldConversionParams == null ||
        oldConversionParams.paramSetValues.isEmpty) {
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

    ConversionParamValueModel newParamValue = paramValues[paramValueIndex];

    ValueModel? newValue;
    ValueModel? newDefaultValue;

    if (delta.newUnit.listType != null) {
      bool belongsToList = ObjectUtils.tryGet(
        await listValueRepository.belongsToList(
          value: newParamValue.value?.raw,
          listType: delta.newUnit.listType!,
        ),
      );

      if (belongsToList) {
        newValue = newParamValue.value;
      }
    } else {
      newValue = newParamValue.value;
    }

    if (newParamValue.defaultValue != null && delta.newUnit.listType == null) {
      newDefaultValue = newParamValue.defaultValue;
    }

    if (newValue == null && newDefaultValue == null) {
      ValueModel? defaultValue = ObjectUtils.tryGet(
        await calculateDefaultValueUseCase.execute(delta.newUnit),
      );
      newParamValue = ConversionParamValueModel(
        param: newParamValue.param,
        unit: delta.newUnit,
        value: delta.newUnit.listType != null ? defaultValue : null,
        defaultValue: delta.newUnit.listType != null ? null : defaultValue,
        calculated: newParamValue.calculated,
      );
    } else {
      newParamValue = ConversionParamValueModel(
        param: newParamValue.param,
        unit: delta.newUnit,
        value: newValue,
        defaultValue: newDefaultValue,
        calculated: newParamValue.calculated,
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
