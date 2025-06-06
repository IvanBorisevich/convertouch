import 'package:convertouch/domain/constants/settings.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_item_unit_replace_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/internal/replace_item_unit_use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';
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
      newUnitValue = _recalculateSrcUnitValue(
        oldUnitValue: oldUnitValue,
        newUnit: delta.newUnit,
        unitGroup: unitGroup,
        params: params,
      );
    }

    if (newUnitValue != null) {
      return oldConvertedUnitValues.map(
            (key, value) =>
        key == delta.oldUnitId
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

  ConversionUnitValueModel _recalculateSrcUnitValue({
    required ConversionUnitValueModel oldUnitValue,
    required UnitModel newUnit,
    required UnitGroupModel unitGroup,
    required ConversionParamSetValueModel? params,
  }) {
    Map<String, String>? mappingTable;
    if (params != null && params.hasAllValues) {
      mappingTable = rules.getMappingTableByParams(
        unitGroupName: unitGroup.name,
        params: params,
      );
    } else {
      mappingTable = rules.getMappingTableByValue(
        unitGroupName: unitGroup.name,
        value: oldUnitValue,
      );
    }

    ConversionRule? xToBase = rules
        .getRule(
          unitGroup: unitGroup,
          unit: oldUnitValue.unit,
          mappingTable: mappingTable,
        )
        ?.xToBase;

    ConversionRule? baseToY = mappingTable != null
        ? UnitRule.mappingTable(
            mapping: mappingTable,
            unitCode: newUnit.code,
          ).baseToY
        : rules
            .getRule(
              unitGroup: unitGroup,
              unit: newUnit,
            )
            ?.baseToY;

    ValueModel? resultValue = Converter(oldUnitValue.value)
        .apply(xToBase)
        .apply(baseToY)
        .value
        ?.betweenOrNull(newUnit.minValue, newUnit.maxValue);

    ValueModel? resultDefValue = newUnit.listType == null
        ? Converter(oldUnitValue.defaultValue)
        .apply(xToBase)
        .apply(baseToY)
        .value
        ?.betweenOrNull(newUnit.minValue, newUnit.maxValue)
        : null;

    return ConversionUnitValueModel(
      unit: newUnit,
      value: resultValue,
      defaultValue: resultDefValue,
    );
  }
}
