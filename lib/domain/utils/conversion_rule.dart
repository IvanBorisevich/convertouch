import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

typedef FunctionWithParams = ValueModel? Function(ValueModel?,
    {ConversionParamSetValueModel? params});
typedef FunctionWithoutParams = ValueModel? Function(ValueModel?);
typedef ParamValueByUnitValueFunc = ValueModel? Function({
  required ValueModel? value,
  required UnitModel unit,
  required ConversionParamSetValueModel params,
});

class Converter {
  final ValueModel? value;
  final ConversionParamSetValueModel? params;

  const Converter(
    this.value, {
    this.params,
  });

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

  ConversionRule.paramByUnitValue({
    required ParamValueByUnitValueFunc? func,
    required UnitModel unit,
  }) : this(
          func: (x, {ConversionParamSetValueModel? params}) {
            return params != null
                ? func?.call(value: x, unit: unit, params: params)
                : null;
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
