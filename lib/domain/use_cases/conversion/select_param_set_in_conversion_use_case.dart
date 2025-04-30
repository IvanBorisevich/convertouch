import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class SelectParamSetInConversionUseCase
    extends AbstractModifyConversionUseCase<SelectParamSetDelta> {
  const SelectParamSetInConversionUseCase({
    required super.convertUnitValuesUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required SelectParamSetDelta delta,
  }) async {
    if (oldConversionParams == null || oldConversionParams.paramSetValues.isEmpty) {
      return oldConversionParams;
    }

    return oldConversionParams.copyWith(
      selectedIndex: delta.newSelectedParamSetIndex,
      selectedParamSetCanBeRemoved: !oldConversionParams
          .paramSetValues[delta.newSelectedParamSetIndex].paramSet.mandatory,
    );
  }
}
