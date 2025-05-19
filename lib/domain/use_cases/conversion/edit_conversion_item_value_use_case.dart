import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';

class EditConversionItemValueUseCase
    extends AbstractModifyConversionUseCase<EditConversionItemValueDelta> {
  const EditConversionItemValueUseCase({
    required super.convertUnitValuesUseCase,
    required super.calculateDefaultValueUseCase,
  });

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required EditConversionItemValueDelta delta,
  }) async {
    UnitModel newUnit = modifiedConvertedItemsMap[delta.unitId]!.unit;
    ValueModel? newDefaultValue;

    if (newUnit.listType == null) {
      newDefaultValue = ValueModel.any(delta.newDefaultValue) ??
          ObjectUtils.tryGet(
            await calculateDefaultValueUseCase.execute(newUnit),
          );
    }

    return ConversionUnitValueModel(
      unit: newUnit,
      value: ValueModel.any(delta.newValue),
      defaultValue: newDefaultValue,
    );
  }

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParamsBySrcUnitValue({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required ConversionUnitValueModel srcUnitValue,
    required UnitGroupModel unitGroup,
    required EditConversionItemValueDelta delta,
  }) async {
    return oldConversionParams?.copyWithChangedParam(
      paramFilter: (p) => p.calculated,
      map: (paramValue, paramSetValue) async {
        return rules.calculateParamValueBySrcValue(
          srcUnitValue: srcUnitValue,
          unitGroupName: unitGroup.name,
          params: paramSetValue,
          param: paramValue.param,
        );
      },
    );
  }
}
