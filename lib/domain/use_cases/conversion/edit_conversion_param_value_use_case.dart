import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';

class EditConversionParamValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionParamValueDelta> {
  const EditConversionParamValueUseCase({
    required super.convertUnitValuesUseCase,
    required super.calculateDefaultValueUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required EditConversionParamValueDelta delta,
  }) async {
    if (oldConversionParams == null ||
        oldConversionParams.paramSetValues.isEmpty) {
      return oldConversionParams;
    }

    return await oldConversionParams.copyWithChangedParamByIds(
      paramSetId: delta.paramSetId,
      paramId: delta.paramId,
      map: (paramValue, paramSetValue) async {
        ValueModel? defaultValue;

        if (paramValue.listType == null) {
          defaultValue = ValueModel.any(delta.newDefaultValue) ??
              ObjectUtils.tryGet(
                await calculateDefaultValueUseCase.execute(paramValue.unit!),
              );
        }

        return ConversionParamValueModel(
          param: paramValue.param,
          unit: paramValue.unit,
          calculated: paramValue.calculated,
          value: ValueModel.any(delta.newValue),
          defaultValue: defaultValue,
        );
      },
    );
  }
}
