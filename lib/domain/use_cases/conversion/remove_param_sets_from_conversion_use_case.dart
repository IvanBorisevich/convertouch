import 'dart:math' show min;

import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';

class RemoveParamSetsFromConversionUseCase
    extends AbstractModifyConversionUseCase<RemoveParamSetsDelta> {
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const RemoveParamSetsFromConversionUseCase({
    required super.convertUnitValuesUseCase,
    required this.calculateDefaultValueUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> newConversionParams({
    required ConversionParamSetValueBulkModel? oldConversionParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required RemoveParamSetsDelta delta,
  }) async {
    if (oldConversionParams == null ||
        oldConversionParams.paramSetValues.isEmpty) {
      return oldConversionParams;
    }

    var newParamSetValues = delta.allOptional
        ? oldConversionParams.paramSetValues
            .where((p) => p.paramSet.mandatory)
            .toList()
        : oldConversionParams.paramSetValues
            .whereIndexed((index, p) =>
                index != oldConversionParams.selectedIndex ||
                p.paramSet.mandatory)
            .toList();

    int newSelectedIndex = min(
      oldConversionParams.selectedIndex,
      newParamSetValues.length - 1,
    );

    return oldConversionParams.copyWith(
      paramSetValues: newParamSetValues,
      selectedIndex: newSelectedIndex,
      paramSetsCanBeAdded: oldConversionParams.mandatoryParamSetExists &&
              newParamSetValues.length < oldConversionParams.totalCount - 1 ||
          newParamSetValues.length < oldConversionParams.totalCount,
      selectedParamSetCanBeRemoved: newParamSetValues.isNotEmpty &&
          !newParamSetValues[newSelectedIndex].paramSet.mandatory,
      paramSetsCanBeRemovedInBulk: newParamSetValues.isNotEmpty &&
          !(newParamSetValues.length == 1 &&
              newParamSetValues.first.paramSet.mandatory),
    );
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel? oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required RemoveParamSetsDelta delta,
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
    ValueModel? defaultValue = ObjectUtils.tryGet(
      await calculateDefaultValueUseCase.execute(srcUnit),
    );
    return ConversionUnitValueModel(
      unit: srcUnit,
      value: srcUnit.listType != null ? defaultValue : null,
      defaultValue: srcUnit.listType != null ? null : defaultValue,
    );
  }
}
