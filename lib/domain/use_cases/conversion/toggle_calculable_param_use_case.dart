import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class ToggleCalculableParamUseCase
    extends AbstractModifyConversionUseCase<ToggleCalculableParamDelta> {
  const ToggleCalculableParamUseCase();

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required ToggleCalculableParamDelta delta,
  }) async {
    return oldConversionParams?.copyWithChangedParamSetByIds(
      map: (paramSetValue) async => paramSetValue.copyWithNewCalculatedParam(
        newCalculatedParamId: delta.paramId,
      ),
      paramSetId: delta.paramSetId,
    );
  }
}
