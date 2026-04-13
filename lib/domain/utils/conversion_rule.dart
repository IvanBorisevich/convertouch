import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

typedef FunctionWithParams = ValueModel? Function(ValueModel?,
    {ConversionParamSetValueModel? params});

typedef FunctionWithoutParams = ValueModel? Function(ValueModel?);

typedef ParamValueFunc = ValueModel? Function(ConversionParamValueModel);

typedef ParamValueBySrcUnitValueFunc = ValueModel? Function({
  required ValueModel? srcValue,
  required UnitModel srcUnit,
  required ConversionParamSetValueModel params,
});

typedef SrcUnitValueByParamValueFunc = ValueModel? Function({
  required UnitModel srcUnit,
  required ParamValueFunc paramValueFunc,
  required ConversionParamSetValueModel params,
});

typedef MappingRuleByParamFunc = Map<String, String>? Function(
  ConversionParamSetValueModel,
);

typedef MappingRuleByUnitValueFunc = Map<String, String>? Function({
  required ValueModel? value,
  required UnitModel unit,
});

// Converters ----------------------------------------------------------------

class Converter {
  final ValueModel? value;
  final ConversionParamSetValueModel? params;

  const Converter(
    this.value, {
    this.params,
  });

  const Converter.noInitValue({this.params}) : value = null;

  Converter apply(ConversionRule? conversionRule) {
    ValueModel? y = conversionRule?.func?.call(value, params: params);
    return Converter(y, params: params);
  }
}

class MappingConverter {
  final Map<String, String>? mapping;

  const MappingConverter(this.mapping);

  ValueModel? valueBySrcValue({
    required ValueModel? srcValue,
    required String srcUnitCode,
    required String tgtUnitCode,
  }) {
    if (srcValue?.raw != mapping?[srcUnitCode]) {
      return null;
    }

    return valueByCode(tgtUnitCode);
  }

  ValueModel? valueByCode(String code) {
    String? value = mapping?[code];

    return value != null ? ValueModel.any(ListValueModel.value(value)) : null;
  }
}

// Conversion rules ----------------------------------------------------------

enum ConversionRuleType {
  xToBase,
  baseToY,
}

class ConversionRule {
  static const identity = ConversionRule(
    func: _identityFunc,
    desc: baseUnitConversionRule,
  );

  final FunctionWithParams? func;
  final String? desc;

  const ConversionRule({
    required this.func,
    this.desc,
  });

  ConversionRule.functionWithoutParams({
    required FunctionWithoutParams? func,
    String? desc,
  }) : this(
          func: func != null
              ? (x, {ConversionParamSetValueModel? params}) => func.call(x)
              : null,
          desc: desc,
        );

  ConversionRule.numFunction({
    required double Function(double)? func,
    String? desc,
  }) : this(
          func: func != null
              ? (x, {ConversionParamSetValueModel? params}) {
                  return x?.numVal != null
                      ? ValueModel.numeric(func.call(x!.numVal!))
                      : null;
                }
              : null,
          desc: desc,
        );

  ConversionRule.paramBySrcValue({
    required ParamValueBySrcUnitValueFunc? func,
    required UnitModel srcUnit,
  }) : this(
          func: (x, {ConversionParamSetValueModel? params}) {
            return params != null
                ? func?.call(srcValue: x, srcUnit: srcUnit, params: params)
                : null;
          },
        );

  ConversionRule.srcValueByParam({
    required ParamValueFunc paramValueFunc,
    required SrcUnitValueByParamValueFunc? srcValueFunc,
    required UnitModel srcUnit,
  }) : this(
          func: (x, {ConversionParamSetValueModel? params}) {
            if (params == null) {
              return null;
            }

            return srcValueFunc?.call(
              srcUnit: srcUnit,
              params: params,
              paramValueFunc: paramValueFunc,
            );
          },
        );

  factory ConversionRule.coefficient(
    double c, {
    required ConversionRuleType ruleType,
    String? desc,
  }) {
    switch (ruleType) {
      case ConversionRuleType.xToBase:
        return ConversionRule.numFunction(
          func: (x) => x * c,
          desc: desc ?? "y = x * $c",
        );
      case ConversionRuleType.baseToY:
        return ConversionRule.numFunction(
          func: (x) => x / c,
          desc: desc ?? "y = x / $c",
        );
    }
  }
}

ValueModel? _identityFunc(
  ValueModel? x, {
  ConversionParamSetValueModel? params,
}) {
  return x;
}
