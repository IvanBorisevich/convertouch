import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class SelectParamSetInConversionUseCase
    extends AbstractModifyConversionUseCase<SelectParamSetDelta> {
  const SelectParamSetInConversionUseCase({
    required super.createConversionUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> modifyConversionParamValues({
    required ConversionParamSetValueBulkModel? currentParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? currentSourceItem,
    required SelectParamSetDelta delta,
  }) async {
    if (currentParams == null || currentParams.paramSetValues.isEmpty) {
      return currentParams;
    }

    return currentParams.copyWith(
      selectedIndex: delta.newSelectedParamSetIndex,
      selectedParamSetCanBeRemoved: !currentParams
          .paramSetValues[delta.newSelectedParamSetIndex].paramSet.mandatory,
    );
  }
}
