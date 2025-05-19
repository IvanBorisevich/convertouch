import 'dart:math' show min;

import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
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
}
