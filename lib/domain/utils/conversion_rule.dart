import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

typedef FunctionWithParams = ValueModel? Function(ValueModel?,
    {ConversionParamSetValueModel? params});
typedef FunctionWithoutParams = ValueModel? Function(ValueModel?);

class Converter {
  final ValueModel? value;

  const Converter(this.value);

  Converter apply(ConversionRule? conversionRule) {
    ValueModel? y = conversionRule?.func?.call(value);
    return Converter(y);
  }
}

class MappingConverter {
  final ValueModel? value;
  final String srcUnitCode;
  final Map<String, String> mapping;

  const MappingConverter(
    this.value, {
    required this.srcUnitCode,
    required this.mapping,
  });

  ValueModel? mappedValue(String tgtUnitCode) {
    if (value?.raw != mapping[srcUnitCode]) {
      return null;
    }

    String? tgtRawValue = mapping[tgtUnitCode];

    return tgtRawValue != null
        ? ValueModel.any(ListValueModel.value(tgtRawValue))
        : null;
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
