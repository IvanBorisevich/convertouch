import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';
import 'package:convertouch/domain/utils/conversion_rules/clothing_size.dart';
import 'package:convertouch/domain/utils/conversion_rules/temperature.dart';

UnitRule? getFormulaRule({
  required String unitGroupName,
  required String unitCode,
}) {
  return _formulaRules[unitGroupName]?[unitCode];
}

UnitRule? getRule({
  required UnitGroupModel unitGroup,
  required UnitModel unit,
}) {
  switch (unitGroup.conversionType) {
    case ConversionType.formula:
      return getFormulaRule(unitGroupName: unitGroup.name, unitCode: unit.code);
    case ConversionType.static:
    case ConversionType.dynamic:
      return UnitRule.coefficient(unit.coefficient!);
  }
}

Map<String, String>? getMappingTable({
  required String unitGroupName,
  required ConversionParamSetValueModel? params,
}) {
  if (params == null) {
    return null;
  }

  return _mappingRules[unitGroupName]?.call(params);
}

final Map<String, Map<String, UnitRule>> _formulaRules = {
  GroupNames.temperature: temperatureRules,
};

typedef MappingRuleFunc = Map<String, String>? Function(
    ConversionParamSetValueModel);

final Map<String, MappingRuleFunc> _mappingRules = {
  GroupNames.clothingSize: getClothingSizesMap,
};
