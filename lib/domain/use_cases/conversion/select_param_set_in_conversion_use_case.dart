import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/list_value_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';

class SelectParamSetInConversionUseCase
    extends AbstractModifyConversionUseCase<SelectParamSetDelta> {
  final ListValueRepository listValueRepository;
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const SelectParamSetInConversionUseCase({
    required super.convertUnitValuesUseCase,
    required this.listValueRepository,
    required this.calculateDefaultValueUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required SelectParamSetDelta delta,
  }) async {
    if (oldConversionParams == null ||
        oldConversionParams.paramSetValues.isEmpty) {
      return oldConversionParams;
    }

    return oldConversionParams.copyWith(
      selectedIndex: delta.newSelectedParamSetIndex,
      selectedParamSetCanBeRemoved: !oldConversionParams
          .paramSetValues[delta.newSelectedParamSetIndex].paramSet.mandatory,
    );
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel? oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required SelectParamSetDelta delta,
  }) async {
    ConversionUnitValueModel newSourceUnitValue =
        oldSourceUnitValue ?? modifiedConvertedItemsMap.values.first;
    UnitModel srcUnit = newSourceUnitValue.unit;

    if (activeParams == null ||
        !activeParams.paramSet.mandatory && !activeParams.applicable) {
      return _calculateDefaults(srcUnit);
    } else {
      return rules.calculateSrcValueByParam(
            params: activeParams,
            unitGroupName: unitGroup.name,
            srcUnit: srcUnit,
          ) ??
          await _calculateDefaults(srcUnit);
    }
  }

  Future<ConversionUnitValueModel> _calculateDefaults(UnitModel srcUnit) async {
    if (srcUnit.listType != null) {
      String? newValue = ObjectUtils.tryGet(
        await listValueRepository.getDefault(
          listType: srcUnit.listType!,
        ),
      )?.itemName;

      return ConversionUnitValueModel(
        unit: srcUnit,
        value: ValueModel.any(newValue),
      );
    } else {
      ValueModel? newDefaultValue = ObjectUtils.tryGet(
        await calculateDefaultValueUseCase.execute(srcUnit),
      );

      return ConversionUnitValueModel(
        unit: srcUnit,
        defaultValue: newDefaultValue,
      );
    }
  }
}
