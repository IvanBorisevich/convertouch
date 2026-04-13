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

typedef MappingRuleByParamFunc = Map<String, String>? Function(
  ConversionParamSetValueModel,
);

typedef MappingRuleByUnitValueFunc = Map<String, String>? Function({
  required ValueModel? value,
  required UnitModel unit,
});

typedef UnitValueByParamFunc = ValueModel? Function({
  required UnitModel unit,
  required ConversionParamSetValueModel params,
});

final Map<String, Map<ConversionRuleType, Map<String, ConversionRule>>>
    _formulaRules = {
  GroupNames.temperature: temperatureRules,
};

const Map<String, MappingRuleByParamFunc> _mappingRulesByParam = {
  GroupNames.clothesSize: getClothesSizesMapByParams,
  GroupNames.ringSize: getRingSizesMapByParams,
};

const Map<String, MappingRuleByUnitValueFunc> _mappingRulesByValue = {
  GroupNames.ringSize: getRingSizesMapByValue,
};

const Map<String, Map<String, Map<String, ParamValueByUnitValueFunc>>>
    _nonListParamBySrcValueRules = {
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
      ParamNames.oneSideWeight: getBarbellOneSideMass,
    },
  },
};

const Map<String, Map<String, UnitValueByParamFunc>>
    _nonListSrcValueByParamsRules = {
  GroupNames.mass: {
    ParamSetNames.barbellWeight: getBarbellFullMass,
  },
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

  for (var tgtUnit in input.targetUnits) {
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
      ),
    );
  }

  return result;
}

ConversionParamValueModel calculateParamValueBySrcValue({
  required ConversionParamModel param,
  required ConversionUnitValueModel srcUnitValue,
  required ConversionParamSetValueModel params,
  required UnitGroupModel unitGroup,
}) {
  ConversionParamValueModel paramValue = params.getParamValue(param.name)!;
  ValueModel? value;
  ValueModel? defaultValue;

  if (param.listType != null) {
    Map<String, String>? mapping = getMappingBySrcValue(
      unitGroupName: unitGroup.name,
      srcUnit: srcUnitValue.unit,
      srcValue: srcUnitValue.eitherValue,
    );

    value = MappingConverter(mapping).valueByCode(srcUnitValue.unit.code);
  } else {
    ConversionRule paramBySrc = ConversionRule.paramByUnitValue(
      func: _nonListParamBySrcValueRules[unitGroup.name]?[params.paramSet.name]
          ?[param.name],
      unit: srcUnitValue.unit,
    );

    value = Converter(srcUnitValue.value, params: params)
        .apply(paramBySrc)
        .value
        ?.betweenOrNull(paramValue.unit?.minValue, paramValue.unit?.maxValue);

    if (srcUnitValue.listType == null) {
      defaultValue = Converter(srcUnitValue.defaultValue, params: params)
          .apply(paramBySrc)
          .value
          ?.betweenOrNull(paramValue.unit?.minValue, paramValue.unit?.maxValue);
    }
  }

  return ConversionParamValueModel(
    param: param,
    unit: paramValue.unit,
    calculated: paramValue.calculated,
    value: value,
    defaultValue: defaultValue,
  );
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
    UnitValueByParamFunc? func =
        _nonListSrcValueByParamsRules[unitGroup.name]?[params.paramSet.name];

    ValueModel? value = func
        ?.call(
          unit: srcUnit,
          params: params,
        )
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
      ? _mappingRulesByValue[unitGroupName]
          ?.call(value: srcValue, unit: srcUnit)
      : null;
}

Map<String, String>? getMappingByParams({
  required String unitGroupName,
  required ConversionParamSetValueModel params,
}) {
  return _mappingRulesByParam[unitGroupName]?.call(params);
}
