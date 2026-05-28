import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_list_values_init_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_unit_replace_model.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/init_item_list_values_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';

class ReplaceConversionItemUnitUseCase
    extends AbstractModifyConversionUseCase<ReplaceConversionItemUnitDelta> {
  final ReplaceUnitInConversionItemUseCase replaceUnitInConversionItemUseCase;
  final InitUnitListValuesUseCase initUnitListValuesUseCase;

  const ReplaceConversionItemUnitUseCase({
    required this.replaceUnitInConversionItemUseCase,
    required this.initUnitListValuesUseCase,
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

    var modifiedConvertedUnitValues = oldConvertedUnitValues;

    if (delta.recalculationMode == RecalculationOnUnitChange.otherValues) {
      modifiedConvertedUnitValues = {};

      for (var unitValue in oldConvertedUnitValues.values) {
        var newUnitValue = ObjectUtils.tryGet(
          await initUnitListValuesUseCase.execute(
            InputUnitListValuesInitModel(
              itemValue: unitValue.unit.id != oldUnitValue.unit.id
                  ? unitValue
                  : unitValue.copyWith(unit: delta.newUnit),
              paramSetValue: params,
            ),
          ),
        );

        modifiedConvertedUnitValues[newUnitValue.unit.id] = newUnitValue;
      }
    }

    ConversionUnitValueModel? newUnitValue;

    if (delta.recalculationMode == RecalculationOnUnitChange.currentValue) {
      newUnitValue = ObjectUtils.tryGet(
        await replaceUnitInConversionItemUseCase.execute(
          InputItemUnitReplaceModel(
            item: oldUnitValue,
            newUnit: delta.newUnit,
          ),
        ),
      );

      newUnitValue = newUnitValue != null
          ? rules
              .calculateUnitValues(
                InputConversionModel(
                  unitGroup: unitGroup,
                  params: params,
                  sourceUnitValue: oldUnitValue,
                  targetItems: [newUnitValue],
                ),
              )
              .first
          : null;
    }

    if (newUnitValue != null) {
      return modifiedConvertedUnitValues.map(
        (key, value) => key == delta.oldUnitId
            ? MapEntry(delta.newUnit.id, newUnitValue!)
            : MapEntry(key, value),
      );
    }

    return modifiedConvertedUnitValues;
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> newConvertedUnitValues,
    required ReplaceConversionItemUnitDelta delta,
  }) async {
    return newConvertedUnitValues[delta.newUnit.id]!;
  }
}
