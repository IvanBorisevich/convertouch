import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_unit_replace_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';

class ReplaceConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionItemUnitDelta> {
  final ReplaceUnitInConversionItemUseCase replaceUnitInConversionItemUseCase;

  const ReplaceConversionItemUnitUseCase({
    required this.replaceUnitInConversionItemUseCase,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required UnitGroupModel unitGroup,
    required ConversionParamSetValueModel? params,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    ConversionUnitValueModel oldUnitValue =
        oldConvertedUnitValues[delta.oldUnitId]!;

    ConversionUnitValueModel? newUnitValue;

    if (delta.recalculationMode == RecalculationOnUnitChange.otherValues) {
      newUnitValue = oldUnitValue.copyWith(
        unit: delta.newUnit,
      );
    }

    if (delta.recalculationMode == RecalculationOnUnitChange.currentValue) {
      newUnitValue = rules
          .calculateUnitValues(
            InputConversionModel(
              unitGroup: unitGroup,
              params: params,
              sourceUnitValue: oldUnitValue,
              targetUnits: [delta.newUnit],
            ),
          )
          .first;
    }

    if (newUnitValue != null) {
      return oldConvertedUnitValues.map(
        (key, value) => key == delta.oldUnitId
            ? MapEntry(delta.newUnit.id, newUnitValue!)
            : MapEntry(key, value),
      );
    }

    return oldConvertedUnitValues;
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> newConvertedUnitValues,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    ConversionUnitValueModel newSrcUnitValue =
        newConvertedUnitValues[delta.newUnit.id]!;

    if (delta.recalculationMode == RecalculationOnUnitChange.otherValues) {
      return ObjectUtils.tryGet(
        await replaceUnitInConversionItemUseCase.execute(
          InputItemUnitReplaceModel(
            item: newSrcUnitValue,
            newUnit: delta.newUnit,
          ),
        ),
      );
    }

    if (delta.recalculationMode == RecalculationOnUnitChange.currentValue) {
      return newSrcUnitValue;
    }

    return oldSourceUnitValue;
  }
}
