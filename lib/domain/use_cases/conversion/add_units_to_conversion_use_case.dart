import 'package:collection/collection.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_modify_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:convertouch/domain/use_cases/conversion/abstract_modify_conversion_use_case.dart';
import 'package:convertouch/domain/use_cases/conversion/calculate_default_value_use_case.dart';
import 'package:convertouch/domain/utils/conversion_rule_utils.dart' as rules;
import 'package:convertouch/domain/utils/object_utils.dart';

class AddUnitsToConversionUseCase
    extends AbstractModifyConversionUseCase<AddUnitsToConversionDelta> {
  final UnitRepository unitRepository;
  final CalculateDefaultValueUseCase calculateDefaultValueUseCase;

  const AddUnitsToConversionUseCase({
    required super.convertUnitValuesUseCase,
    required this.calculateDefaultValueUseCase,
    required this.unitRepository,
  });

  @override
  Future<Map<int, ConversionUnitValueModel>> newConvertedUnitValues({
    required Map<int, ConversionUnitValueModel> oldConvertedUnitValues,
    required AddUnitsToConversionDelta delta,
  }) async {
    List<int> newUnitIds = delta.unitIds
        .whereNot((id) => oldConvertedUnitValues.keys.contains(id))
        .toList();

    final newUnits = ObjectUtils.tryGet(
      await unitRepository.getByIds(newUnitIds),
    );

    final newConversionItemsMap = {
      for (var unit in newUnits)
        unit.id: ConversionUnitValueModel(
          unit: unit,
        )
    };

    return {
      ...oldConvertedUnitValues,
      ...newConversionItemsMap,
    };
  }

  @override
  Future<ConversionUnitValueModel> newSourceUnitValue({
    required ConversionUnitValueModel? oldSourceUnitValue,
    required ConversionParamSetValueModel? activeParams,
    required UnitGroupModel unitGroup,
    required Map<int, ConversionUnitValueModel> modifiedConvertedItemsMap,
    required AddUnitsToConversionDelta delta,
  }) async {
    if (oldSourceUnitValue != null) {
      var unit = oldSourceUnitValue.unit;
      var value = oldSourceUnitValue.value;
      var defaultValue = oldSourceUnitValue.defaultValue;

      return ConversionUnitValueModel(
        unit: unit,
        value: value ?? (unit.listType != null ? defaultValue : null),
        defaultValue: unit.listType == null ? defaultValue : null,
      );
    }

    UnitModel newUnit = modifiedConvertedItemsMap.values.first.unit;
    ValueModel? newDefaultValue;

    Map<String, String>? mappingTable;
    if (activeParams != null && activeParams.applicable) {
      mappingTable = rules.getMappingTableByParams(
        unitGroupName: unitGroup.name,
        params: activeParams,
      );
    } else {
      mappingTable = rules.getMappingTableByValue(
        unitGroupName: unitGroup.name,
        value: oldSourceUnitValue,
      );
    }

    if (mappingTable != null) {
      newDefaultValue = ValueModel.any(mappingTable[newUnit.code]);
    } else {
      newDefaultValue = ObjectUtils.tryGet(
        await calculateDefaultValueUseCase.execute(newUnit),
      );
    }

    return ConversionUnitValueModel(
      unit: newUnit,
      value: newUnit.listType != null ? newDefaultValue : null,
      defaultValue: newUnit.listType == null ? newDefaultValue : null,
    );
  }
}
