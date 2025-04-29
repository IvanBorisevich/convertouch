import 'dart:math' show max, min;

import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';

class RemoveParamSetsFromConversionUseCase
    extends AbstractModifyConversionUseCase<RemoveParamSetsDelta> {
  const RemoveParamSetsFromConversionUseCase({
    required super.convertUnitValuesUseCase,
    required super.calculateDefaultValueUseCase,
  });

  @override
  Future<ConversionParamSetValueBulkModel?> modifyConversionParamValues({
    required ConversionParamSetValueBulkModel? currentParams,
    required UnitGroupModel unitGroup,
    required ConversionUnitValueModel? srcUnitValue,
    required RemoveParamSetsDelta delta,
  }) async {
    if (currentParams == null || currentParams.paramSetValues.isEmpty) {
      return currentParams;
    }

    var newParamSetValues = delta.allOptional
        ? currentParams.paramSetValues
            .where((p) => p.paramSet.mandatory)
            .toList()
        : currentParams.paramSetValues
            .whereIndexed((index, p) =>
                index != currentParams.selectedIndex || p.paramSet.mandatory)
            .toList();

    int newSelectedIndex = delta.allOptional
        ? 0
        : max(
            0,
            min(currentParams.selectedIndex, newParamSetValues.length - 1),
          );

    return currentParams.copyWith(
      paramSetValues: newParamSetValues,
      selectedIndex: newSelectedIndex,
      paramSetsCanBeAdded: currentParams.mandatoryParamSetExists &&
              newParamSetValues.length < currentParams.totalCount - 1 ||
          newParamSetValues.length < currentParams.totalCount,
      selectedParamSetCanBeRemoved: newParamSetValues.isNotEmpty &&
          !newParamSetValues[newSelectedIndex].paramSet.mandatory,
      paramSetsCanBeRemovedInBulk: newParamSetValues.isNotEmpty &&
          !(newParamSetValues.length == 1 &&
              newParamSetValues.first.paramSet.mandatory),
    );
  }
}
