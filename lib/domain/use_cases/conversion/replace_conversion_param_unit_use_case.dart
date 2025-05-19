import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class ReplaceConversionParamUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionParamUnitDelta> {
  final ListValueRepository listValueRepository;

  const ReplaceConversionParamUnitUseCase({
    required super.convertUnitValuesUseCase,
    required super.calculateDefaultValueUseCase,
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

    return await oldConversionParams.copyWithChangedParamByIds(
      paramSetId: delta.paramSetId,
      paramId: delta.paramId,
      map: (paramValue, paramSetValue) async {
        ValueModel? newValue;
        ValueModel? newDefaultValue;

        if (delta.newUnit.listType != null) {
          bool belongsToList = ObjectUtils.tryGet(
            await listValueRepository.belongsToList(
              value: paramValue.value?.raw,
              listType: delta.newUnit.listType!,
              coefficient: delta.newUnit.coefficient,
            ),
          );

          if (belongsToList) {
            newValue = paramValue.value;
          }
        } else {
          newValue = paramValue.value;
        }

        if (paramValue.defaultValue != null && delta.newUnit.listType == null) {
          newDefaultValue = paramValue.defaultValue;
        }

        if (newValue == null && newDefaultValue == null) {
          ValueModel? defaultValue = ObjectUtils.tryGet(
            await calculateDefaultValueUseCase.execute(delta.newUnit),
          );
          return ConversionParamValueModel(
            param: paramValue.param,
            unit: delta.newUnit,
            value: delta.newUnit.listType != null ? defaultValue : null,
            defaultValue: delta.newUnit.listType != null ? null : defaultValue,
            calculated: paramValue.calculated,
          );
        } else {
          return ConversionParamValueModel(
            param: paramValue.param,
            unit: delta.newUnit,
            value: newValue,
            defaultValue: newDefaultValue,
            calculated: paramValue.calculated,
          );
        }
      },
    );
  }
}
