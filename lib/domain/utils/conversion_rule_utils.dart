import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
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

ValueModel? calculateParamValueBySrcValue({
  required ConversionUnitValueModel srcUnitValue,
  required String unitGroupName,
  required ConversionParamSetValueModel params,
  required String paramName,
}) {
  ConversionParamValueModel? paramValue = params.getParam(paramName);
  if (paramValue == null) {
    return null;
  }

  if (paramValue.param.listType != null) {
    Map<String, String>? mappingTable = getMappingTableByValue(
      unitGroupName: unitGroupName,
      value: srcUnitValue,
    );

    String? newValue = mappingTable?[srcUnitValue.unit.code];
    return ValueModel.any(newValue);
  } else {
    ParamByValueFunc? func = _nonListParamValueBySrcValueRules[unitGroupName]
        ?[params.paramSet.name]?[paramName];

    return func?.call(
      value: srcUnitValue,
      paramValues: params.paramValues,
    );
  }
}

ConversionUnitValueModel? calculateSrcValueByParam({
  required ConversionParamSetValueModel params,
  required UnitModel srcUnit,
  required String unitGroupName,
}) {
  if (srcUnit.listType != null) {
    Map<String, String>? mappingTable = getMappingTableByParams(
      unitGroupName: unitGroupName,
      params: params,
    );

    String? newValue = mappingTable?[srcUnit.code];
    return ConversionUnitValueModel(
      unit: srcUnit,
      value: ValueModel.any(newValue),
    );
  } else {
    ValueByParamFunc? func =
        _nonListSrcValueByParamValueRules[unitGroupName]?[params.paramSet.name];

    return func?.call(
      unit: srcUnit,
      params: params,
    );
  }
}

typedef MappingRuleByParamFunc = Map<String, String>? Function(
  ConversionParamSetValueModel,
);

typedef MappingRuleByUnitValueFunc = Map<String, String>? Function(
  ConversionUnitValueModel,
);

typedef ParamByValueFunc = ValueModel? Function({
  required ConversionUnitValueModel value,
  required List<ConversionParamValueModel> paramValues,
});

typedef ValueByParamFunc = ConversionUnitValueModel? Function({
  required UnitModel unit,
  required ConversionParamSetValueModel params,
});

final Map<String, Map<String, UnitRule>> _formulaRules = {
  GroupNames.temperature: temperatureRules,
};

const Map<String, Map<String, MappingRuleByParamFunc>> _mappingRulesByParam = {
  GroupNames.clothingSize: {
    ParamSetNames.byHeight: getClothingSizesMap,
  },
  GroupNames.ringSize: {
    ParamSetNames.byDiameter: getRingSizesMapByDiameter,
    ParamSetNames.byCircumference: getRingSizesMapByCircumference,
  }
};

const Map<String, MappingRuleByUnitValueFunc> _mappingRulesByValue = {
  GroupNames.ringSize: getRingSizesMapByValue,
};

const Map<String, Map<String, Map<String, ParamByValueFunc>>>
    _nonListParamValueBySrcValueRules = {
  GroupNames.ringSize: {
    ParamSetNames.byDiameter: {
      ParamNames.diameter: getDiameterByValue,
    },
    ParamSetNames.byCircumference: {
      ParamNames.circumference: getCircumferenceByValue,
    },
  }
};

const Map<String, Map<String, ValueByParamFunc>>
    _nonListSrcValueByParamValueRules = {};
