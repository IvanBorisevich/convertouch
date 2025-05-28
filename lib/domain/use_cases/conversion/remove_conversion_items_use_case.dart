import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class RemoveConversionItemsUseCase
    extends AbstractModifyConversionUseCase<RemoveConversionItemsDelta> {
  const RemoveConversionItemsUseCase();

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required RemoveConversionItemsDelta delta,
  }) async {
    oldConvertedUnitValues.removeWhere(
      (unitId, item) => delta.unitIds.contains(unitId),
    );
    return oldConvertedUnitValues;
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> newConvertedUnitValues,
    required RemoveConversionItemsDelta delta,
  }) async {
    if (!delta.unitIds.contains(oldSourceUnitValue.unit.id)) {
      return oldSourceUnitValue;
    }
    return newConvertedUnitValues.values.first;
  }
}
