import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';
import 'package:convertouch/domain/utils/conversion_rules/barbell_weight.dart';
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

  return _mappingRulesByParam[unitGroupName]?.call(params);
}

Map<String, String>? getMappingTableByValue({
  required String unitGroupName,
  required ConversionUnitValueModel? value,
}) {
  if (value == null || !value.hasValue) {
    return null;
  }

  return _mappingRulesByValue[unitGroupName]?.call(value);
}

ConversionParamValueModel calculateParamValueBySrcValue({
  required ConversionParamModel param,
  required ConversionUnitValueModel srcUnitValue,
  required ConversionParamSetValueModel params,
  required String unitGroupName,
}) {
  if (param.listType != null) {
    Map<String, String>? mappingTable = getMappingTableByValue(
      unitGroupName: unitGroupName,
      value: srcUnitValue,
    );

    String? newValue = mappingTable?[srcUnitValue.unit.code];
    return ConversionParamValueModel(
      param: param,
      value: ValueModel.any(newValue),
    );
  } else {
    ParamValueByUnitValueFunc? func =
        _nonListParamValueBySrcValueRules[unitGroupName]?[params.paramSet.name]
            ?[param.name];

    ConversionParamValueModel paramValue = params.getParam(param.name)!;

    ValueModel? value = func
        ?.call(
          value: srcUnitValue,
          paramValues: params.paramValues,
        )
        ?.betweenOrNull(paramValue.unit?.minValue, paramValue.unit?.maxValue);

    ValueModel? defaultValue = value == null ? null : paramValue.defaultValue;

    return ConversionParamValueModel(
      param: param,
      unit: paramValue.unit,
      calculated: paramValue.calculated,
      value: value,
      defaultValue: defaultValue,
    );
  }
}

ConversionUnitValueModel calculateSrcValueByParams({
  required UnitModel srcUnit,
  required ConversionParamSetValueModel params,
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
    UnitValueByParamValuesFunc? func =
        _nonListSrcValueByParamValuesRules[unitGroupName]
            ?[params.paramSet.name];

    ValueModel? value = func
        ?.call(
          unit: srcUnit,
          paramValues: params.paramValues,
        )
        ?.betweenOrNull(srcUnit.minValue, srcUnit.maxValue);

    return ConversionUnitValueModel(
      unit: srcUnit,
      value: value,
    );
  }
}

typedef MappingRuleByParamFunc = Map<String, String>? Function(
  ConversionParamSetValueModel,
);

typedef MappingRuleByUnitValueFunc = Map<String, String>? Function(
  ConversionUnitValueModel,
);

typedef ParamValueByUnitValueFunc = ValueModel? Function({
  required ConversionUnitValueModel value,
  required List<ConversionParamValueModel> paramValues,
});

typedef UnitValueByParamValuesFunc = ValueModel? Function({
  required UnitModel unit,
  required List<ConversionParamValueModel> paramValues,
});

final Map<String, Map<String, UnitRule>> _formulaRules = {
  GroupNames.temperature: temperatureRules,
};

const Map<String, MappingRuleByParamFunc> _mappingRulesByParam = {
  GroupNames.clothingSize: getClothingSizesMap,
  GroupNames.ringSize: getRingSizesMap,
};

const Map<String, MappingRuleByUnitValueFunc> _mappingRulesByValue = {
  GroupNames.ringSize: getRingSizesMapByValue,
};

const Map<String, Map<String, Map<String, ParamValueByUnitValueFunc>>>
    _nonListParamValueBySrcValueRules = {
  GroupNames.ringSize: {
    ParamSetNames.byDiameter: {
      ParamNames.diameter: getDiameterByValue,
    },
    ParamSetNames.byCircumference: {
      ParamNames.circumference: getCircumferenceByValue,
    },
  },
  GroupNames.mass: {
    ParamSetNames.barbellWeight: {
      ParamNames.oneSideWeight: getBarbellOneSideWeight,
    },
  },
};

const Map<String, Map<String, UnitValueByParamValuesFunc>>
    _nonListSrcValueByParamValuesRules = {
  GroupNames.mass: {
    ParamSetNames.barbellWeight: getBarbellFullWeight,
  },
};
