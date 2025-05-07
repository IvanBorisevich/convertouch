import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';
import 'package:convertouch/domain/utils/conversion_rules/clothing_size.dart';
import 'package:convertouch/domain/utils/conversion_rules/ring_size.dart';
import 'package:convertouch/domain/utils/conversion_rules/temperature.dart';

UnitRule? getRule({
  required UnitGroupModel unitGroup,
  required UnitModel unit,
  Map<String, String>? mappingTable,
}) {
  switch (unitGroup.conversionType) {
    case ConversionType.formula:
      return mappingTable != null
          ? UnitRule.mappingTable(
              mapping: mappingTable,
              unitCode: unit.code,
            )
          : getFormulaRule(
              unitGroupName: unitGroup.name,
              unitCode: unit.code,
            );
    case ConversionType.static:
    case ConversionType.dynamic:
      return UnitRule.coefficient(unit.coefficient!);
  }
}

UnitRule? getFormulaRule({
  required String unitGroupName,
  required String unitCode,
}) {
  return _formulaRules[unitGroupName]?[unitCode];
}

Map<String, String>? getMappingTableByParams({
  required String unitGroupName,
  required ConversionParamSetValueModel? params,
}) {
  if (params == null) {
    return null;
  }

  return _mappingRulesByParam[unitGroupName]?[params.paramSet.name]
      ?.call(params);
}

Map<String, String>? getMappingTableByValue({
  required String unitGroupName,
  required ConversionUnitValueModel? value,
}) {
  if (value == null || value.isEmpty) {
    return null;
  }

  return _mappingRulesByValue[unitGroupName]?.call(value);
}

typedef MappingRuleByParamFunc = Map<String, String>? Function(
  ConversionParamSetValueModel,
);

typedef MappingRuleByUnitValueFunc = Map<String, String>? Function(
  ConversionUnitValueModel,
);

final Map<String, Map<String, UnitRule>> _formulaRules = {
  GroupNames.temperature: temperatureRules,
};

final Map<String, Map<String, MappingRuleByParamFunc>> _mappingRulesByParam = {
  GroupNames.clothingSize: {
    ParamSetNames.byHeight: getClothingSizesMap,
  },
  GroupNames.ringSize: {
    ParamSetNames.byDiameter: (params) =>
        getRingSizesMapByParams(params, ParamNames.diameter),
    ParamSetNames.byCircumference: (params) =>
        getRingSizesMapByParams(params, ParamNames.circumference),
  }
};

final Map<String, MappingRuleByUnitValueFunc> _mappingRulesByValue = {
  GroupNames.ringSize: getRingSizesMapByValue,
};
