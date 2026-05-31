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
import 'package:convertouch/domain/utils/list_values_utils.dart';

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

  List<ConversionUnitValueModel> result = [];

  for (var tgtItem in input.targetItems) {
    var tgtUnit = tgtItem.unit;

    if (tgtUnit.name == input.sourceUnitValue.unit.name) {
      result.add(input.sourceUnitValue);
      continue;
    }

    ValueModel? value = calculateTargetValue(
      unitGroup: input.unitGroup,
      srcValue: input.sourceUnitValue.value,
      srcUnit: input.sourceUnitValue.unit,
      tgtUnit: tgtUnit,
      mapping: mappingTable,
    );

    ValueModel? defaultValue = calculateTargetValue(
      unitGroup: input.unitGroup,
      srcValue: input.sourceUnitValue.defaultValue,
      srcUnit: input.sourceUnitValue.unit,
      tgtUnit: tgtUnit,
      mapping: mappingTable,
    );

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

ConversionUnitValueModel calculateUnitValueForNewUnit({
  required ConversionUnitValueModel unitValue,
  required UnitModel tgtParamUnit,
  ConversionParamSetValueModel? params,
  required UnitGroupModel paramUnitGroup,
}) {
  return calculateUnitValues(
    InputConversionModel(
      unitGroup: paramUnitGroup,
      params: params,
      sourceUnitValue: unitValue,
      targetItems: [ConversionUnitValueModel(unit: tgtParamUnit)],
    ),
  ).first;
}

ConversionParamValueModel calculateParamValueForNewUnit({
  required ConversionParamValueModel paramValue,
  required UnitModel tgtParamUnit,
  required ConversionParamSetValueModel params,
  required UnitGroupModel paramUnitGroup,
}) {
  if (paramValue.unit == null) {
    return paramValue;
  }

  if (paramValue.listType != null && paramValue.unit!.listType == null) {
    if (paramValue.value == null) {
      return paramValue;
    }

    var listValueFuncSet = listValuesFuncSets[paramValue.listType];

    if (listValueFuncSet == null) {
      return paramValue;
    }

    String? listPublicValue = listValueFuncSet.publicListValueBuilderFunc.call(
      listValueFuncSet.listValueToRawMapFunc.call(paramValue.value!),
      unit: tgtParamUnit,
      params: params,
    );

    return ConversionParamValueModel(
      param: paramValue.param,
      value: paramValue.value!.copyWith(
        alt: listPublicValue,
      ),
      unit: tgtParamUnit,
    );
  }

  Map<String, String>? mappingTable;
  if (paramValue.listType == null && paramValue.unit!.listType != null) {
    mappingTable = getMappingByParams(
      unitGroupName: paramUnitGroup.name,
      params: params,
    );
  }

  ValueModel? value = calculateTargetValue(
    unitGroup: paramUnitGroup,
    srcValue: paramValue.value,
    srcUnit: paramValue.unit!,
    tgtUnit: tgtParamUnit,
    mapping: mappingTable,
  );

  ValueModel? defaultValue = calculateTargetValue(
    unitGroup: paramUnitGroup,
    srcValue: paramValue.defaultValue,
    srcUnit: paramValue.unit!,
    tgtUnit: tgtParamUnit,
    mapping: mappingTable,
  );

  return ConversionParamValueModel(
    param: paramValue.param,
    value: value,
    defaultValue: defaultValue,
    unit: tgtParamUnit,
  );
}

ValueModel? calculateTargetValue({
  required UnitGroupModel unitGroup,
  required ValueModel? srcValue,
  required UnitModel srcUnit,
  required UnitModel tgtUnit,
  Map<String, String>? mapping,
}) {
  MappingConverter mappingConverter = MappingConverter(mapping).bySrcValue(
    srcValue: srcValue,
    srcUnitCode: srcUnit.code,
  );

  if (mappingConverter.isNotEmpty) {
    return mappingConverter.valueByCode(tgtUnit.code);
  } else {
    ConversionRule? xToBase = getRule(
      unitGroup: unitGroup,
      ruleType: ConversionRuleType.xToBase,
      unit: srcUnit,
    );

    ConversionRule? baseToY = getRule(
      unitGroup: unitGroup,
      ruleType: ConversionRuleType.baseToY,
      unit: tgtUnit,
    );

    return Converter(srcValue)
        .apply(xToBase)
        .apply(baseToY)
        .value
        ?.betweenOrNull(tgtUnit.minValue, tgtUnit.maxValue);
  }
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

  ValueModel? result = Converter(
    srcUnitValue.value ?? srcUnitValue.defaultValue,
    params: params,
  )
      .apply(paramBySrc)
      .value
      ?.betweenOrNull(paramValue.unit?.minValue, paramValue.unit?.maxValue);

  if (result == null) {
    return null;
  }

  if (param.listType != null) {
    ListValueFuncSet? listValueFuncSet = listValuesFuncSets[param.listType];

    if (listValueFuncSet == null) {
      return result;
    }

    return listValueFuncSet.recalculatePublicValueForUnit(
      result,
      unit: paramValue.unit,
      params: params,
    );
  }

  return result;
}

ConversionUnitValueModel calculateSrcValueByParams({
  required UnitModel srcUnit,
  required ConversionParamSetValueModel params,
  required String unitGroupName,
}) {
  if (srcUnit.listType != null) {
    Map<String, String>? mapping = getMappingByParams(
      unitGroupName: unitGroupName,
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
      srcValueFunc: _nonListSrcValueByParamsRules[unitGroupName]
          ?[params.paramSet.name],
      srcUnit: srcUnit,
    );

    ConversionRule srcByParamForDefault = ConversionRule.srcValueByParam(
      paramValueFunc: (paramValue) => paramValue.listType == null
          ? paramValue.defaultValue
          : paramValue.value,
      srcValueFunc: _nonListSrcValueByParamsRules[unitGroupName]
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
      return unit.coefficient != null
          ? ConversionRule.coefficient(
              unit.coefficient!,
              ruleType: ruleType,
            )
          : null;
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
