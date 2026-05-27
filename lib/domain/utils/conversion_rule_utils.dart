import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_conversion_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';
import 'package:convertouch/domain/utils/conversion_rules/barbell_mass.dart';
import 'package:convertouch/domain/utils/conversion_rules/clothes_size.dart';
import 'package:convertouch/domain/utils/conversion_rules/ring_size.dart';
import 'package:convertouch/domain/utils/conversion_rules/temperature.dart';

// Function rules

final Map<String, Map<ConversionRuleType, Map<String, ConversionRule>>>
    _formulaRules = {
  GroupNames.temperature: temperatureRules,
};

const Map<String, Map<String, Map<String, ParamValueBySrcUnitValueFunc>>>
    _paramBySrcValueRules = {
  GroupNames.clothesSize: {
    ParamSetNames.byHeight: {
      ParamNames.height: getHeightByClothesSize,
    },
  },
  GroupNames.ringSize: {
    ParamSetNames.byDiameter: {
      ParamNames.diameter: getDiameterByRingSize,
    },
    ParamSetNames.byCircumference: {
      ParamNames.circumference: getCircumferenceByRingSize,
    },
  },
  GroupNames.mass: {
    ParamSetNames.barbellWeight: {
      ParamNames.oneSideWeight: getBarbellOneSideMassByFullMass,
    },
  },
};

const Map<String, Map<String, SrcUnitValueByParamValueFunc>>
    _nonListSrcValueByParamsRules = {
  GroupNames.mass: {
    ParamSetNames.barbellWeight: getBarbellFullMass,
  },
};

// Mapping rules -------------------------------------------------------------

const Map<String, MappingRuleByParamFunc> _mappingRulesByParam = {
  GroupNames.clothesSize: getClothesSizesMapByParams,
  GroupNames.ringSize: getRingSizesMapByParams,
};

const Map<String, MappingRuleBySrcUnitValueFunc> _mappingRulesBySrcUnitValue = {
  GroupNames.ringSize: getRingSizesMapByValue,
};

//----------------------------------------------------------------------------

List<ConversionUnitValueModel> calculateUnitValues(
  InputConversionModel input,
) {
  Map<String, String>? mappingTable;

  if (input.params != null && input.params!.hasAllValues) {
    mappingTable = getMappingByParams(
      unitGroupName: input.unitGroup.name,
      params: input.params!,
    );
  } else {
    mappingTable = getMappingBySrcValue(
      unitGroupName: input.unitGroup.name,
      srcUnit: input.sourceUnitValue.unit,
      srcValue: input.sourceUnitValue.eitherValue,
    );
  }

  ConversionRule? xToBase = getRule(
    unitGroup: input.unitGroup,
    ruleType: ConversionRuleType.xToBase,
    unit: input.sourceUnitValue.unit,
  );

  List<ConversionUnitValueModel> result = [];

  for (var tgtItem in input.targetItems) {
    var tgtUnit = tgtItem.unit;

    if (tgtUnit.name == input.sourceUnitValue.unit.name) {
      result.add(input.sourceUnitValue);
      continue;
    }

    ConversionRule? baseToY = getRule(
      unitGroup: input.unitGroup,
      ruleType: ConversionRuleType.baseToY,
      unit: tgtUnit,
    );

    ValueModel? value;

    if (mappingTable != null) {
      value = MappingConverter(mappingTable).valueBySrcValue(
        srcValue: input.sourceUnitValue.value,
        srcUnitCode: input.sourceUnitValue.unit.code,
        tgtUnitCode: tgtUnit.code,
      );
    } else {
      value = Converter(input.sourceUnitValue.value)
          .apply(xToBase)
          .apply(baseToY)
          .value
          ?.betweenOrNull(tgtUnit.minValue, tgtUnit.maxValue);
    }

    ValueModel? defaultValue;

    if (tgtUnit.listType == null) {
      defaultValue = Converter(input.sourceUnitValue.defaultValue)
          .apply(xToBase)
          .apply(baseToY)
          .value
          ?.betweenOrNull(tgtUnit.minValue, tgtUnit.maxValue);
    }

    result.add(
      ConversionUnitValueModel(
        unit: tgtUnit,
        value: value,
        defaultValue: defaultValue,
        listValues: tgtItem.listValues,
      ),
    );
  }

  return result;
}

ValueModel? calculateTargetParamValue({
  required ConversionParamValueModel paramValue,
  required UnitModel tgtParamUnit,
  required ConversionParamSetValueModel params,
  required UnitGroupModel paramUnitGroup,
}) {
  if (paramValue.unit == null) {
    return null;
  }

  if (paramValue.listType == null && paramValue.unit!.listType != null) {
    Map<String, String>? mappingTable = getMappingByParams(
      unitGroupName: paramUnitGroup.name,
      params: params,
    );

    if (mappingTable != null) {
      return MappingConverter(mappingTable).valueBySrcValue(
        srcValue: paramValue.value,
        srcUnitCode: paramValue.unit!.code,
        tgtUnitCode: tgtParamUnit.code,
      );
    }
  }

  if (paramValue.listType != null && paramValue.unit!.listType == null) {
    var srcValue = paramValue.value;
    var srcUnit = paramValue.unit!;
    var tgtUnit = tgtParamUnit;

    ConversionRule? xToBase = getRule(
      unitGroup: paramUnitGroup,
      ruleType: ConversionRuleType.xToBase,
      unit: srcUnit,
    );

    ConversionRule? baseToY = getRule(
      unitGroup: paramUnitGroup,
      ruleType: ConversionRuleType.baseToY,
      unit: tgtUnit,
    );

    return Converter(srcValue)
        .apply(xToBase)
        .apply(baseToY)
        .value
        ?.betweenOrNull(tgtUnit.minValue, tgtUnit.maxValue);
  }

  return null;
}

ValueModel? calculateParamValueBySrcValue({
  required ConversionParamModel param,
  required ConversionUnitValueModel srcUnitValue,
  required ConversionParamSetValueModel params,
  required String unitGroupName,
}) {
  ConversionParamValueModel paramValue = params.getParamValue(param.name)!;

  ConversionRule paramBySrc = ConversionRule.paramBySrcValue(
    func: _paramBySrcValueRules[unitGroupName]?[params.paramSet.name]
        ?[param.name],
    srcUnit: srcUnitValue.unit,
  );

  return Converter(
    srcUnitValue.value ?? srcUnitValue.defaultValue,
    params: params,
  )
      .apply(paramBySrc)
      .value
      ?.betweenOrNull(paramValue.unit?.minValue, paramValue.unit?.maxValue);
}

ConversionUnitValueModel calculateSrcValueByParams({
  required UnitModel srcUnit,
  required ValueModel? defaultValue,
  required ConversionParamSetValueModel params,
  required UnitGroupModel unitGroup,
}) {
  if (srcUnit.listType != null) {
    Map<String, String>? mapping = getMappingByParams(
      unitGroupName: unitGroup.name,
      params: params,
    );

    ValueModel? value = MappingConverter(mapping).valueByCode(srcUnit.code);

    return ConversionUnitValueModel(
      unit: srcUnit,
      value: value,
    );
  } else {
    ConversionRule srcByParam = ConversionRule.srcValueByParam(
      paramValueFunc: (paramValue) => paramValue.value,
      srcValueFunc: _nonListSrcValueByParamsRules[unitGroup.name]
          ?[params.paramSet.name],
      srcUnit: srcUnit,
    );

    ConversionRule srcByParamForDefault = ConversionRule.srcValueByParam(
      paramValueFunc: (paramValue) => paramValue.listType == null
          ? paramValue.defaultValue
          : paramValue.value,
      srcValueFunc: _nonListSrcValueByParamsRules[unitGroup.name]
          ?[params.paramSet.name],
      srcUnit: srcUnit,
    );

    ValueModel? value = Converter.noInitValue(params: params)
        .apply(srcByParam)
        .value
        ?.betweenOrNull(srcUnit.minValue, srcUnit.maxValue);

    ValueModel? defaultValue = Converter.noInitValue(params: params)
        .apply(srcByParamForDefault)
        .value
        ?.betweenOrNull(srcUnit.minValue, srcUnit.maxValue);

    return ConversionUnitValueModel(
      unit: srcUnit,
      value: value,
      defaultValue: defaultValue,
    );
  }
}

ConversionRule? getRule({
  required UnitGroupModel unitGroup,
  required UnitModel unit,
  required ConversionRuleType ruleType,
}) {
  switch (unitGroup.conversionType) {
    case ConversionType.formula:
      return _formulaRules[unitGroup.name]?[ruleType]?[unit.code];
    case ConversionType.static:
    case ConversionType.dynamic:
      return ConversionRule.coefficient(
        unit.coefficient!,
        ruleType: ruleType,
      );
  }
}

Map<String, String>? getMappingBySrcValue({
  required String unitGroupName,
  required ValueModel? srcValue,
  required UnitModel srcUnit,
}) {
  return srcValue != null
      ? _mappingRulesBySrcUnitValue[unitGroupName]
          ?.call(value: srcValue, unit: srcUnit)
      : null;
}

Map<String, String>? getMappingByParams({
  required String unitGroupName,
  required ConversionParamSetValueModel params,
}) {
  return _mappingRulesByParam[unitGroupName]?.call(params);
}
