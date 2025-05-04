import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

typedef FunctionWithParams = ValueModel? Function(
    ValueModel, ConversionParamSetValueModel params);
typedef FunctionWithOptionalParams = ValueModel? Function(ValueModel,
    {ConversionParamSetValueModel? params});
typedef FunctionWithoutParams = ValueModel? Function(ValueModel);

ValueModel _identityFunc(
  ValueModel x, {
  ConversionParamSetValueModel? params,
}) {
  return x;
}

class Converter {
  final ValueModel? value;
  final ConversionParamSetValueModel? params;

  const Converter(
    this.value, {
    this.params,
  });

  Converter apply(ConversionRule? conversionRule) {
    ValueModel? y = value != null && conversionRule != null
        ? conversionRule.func?.call(value!, params: params)
        : null;
    return Converter(y, params: params);
  }
}

class ConversionRule {
  static const identity = ConversionRule(
    func: _identityFunc,
    desc: baseUnitConversionRule,
  );

  final FunctionWithOptionalParams? func;
  final String? desc;

  const ConversionRule({
    required this.func,
    this.desc,
  });

  ConversionRule.withParams({
    required FunctionWithParams? func,
    String? desc,
  }) : this(
          func: func != null
              ? (x, {ConversionParamSetValueModel? params}) =>
                  func.call(x, params!)
              : null,
          desc: desc,
        );

  ConversionRule.noParams({
    required FunctionWithoutParams? func,
    String? desc,
  }) : this(
          func: func != null
              ? (x, {ConversionParamSetValueModel? params}) => func.call(x)
              : null,
          desc: desc,
        );

  ConversionRule.num({
    required double Function(double)? func,
    String? desc,
  }) : this(
          func: func != null
              ? (x, {ConversionParamSetValueModel? params}) =>
                  ValueModel.numeric(func.call(x.numVal!))
              : null,
          desc: desc,
        );
}

class UnitRule {
  static const identity = UnitRule(
    xToBase: ConversionRule.identity,
    baseToY: ConversionRule.identity,
  );

  final ConversionRule xToBase;
  final ConversionRule baseToY;

  const UnitRule({
    required this.xToBase,
    required this.baseToY,
  });

  UnitRule.plain({
    required FunctionWithOptionalParams? xToBase,
    required FunctionWithOptionalParams? baseToY,
    String? xToBaseStr,
    String? baseToYStr,
  }) : this(
          xToBase: ConversionRule(
            func: xToBase,
            desc: xToBaseStr,
          ),
          baseToY: ConversionRule(
            func: baseToY,
            desc: baseToYStr,
          ),
        );

  UnitRule.num({
    required double Function(double)? xToBase,
    required double Function(double)? baseToY,
    String? xToBaseStr,
    String? baseToYStr,
  }) : this(
          xToBase: ConversionRule.num(
            func: xToBase,
            desc: xToBaseStr,
          ),
          baseToY: ConversionRule.num(
            func: baseToY,
            desc: baseToYStr,
          ),
        );

  UnitRule.coefficient(double c)
      : this.num(
          xToBase: (x) => x * c,
          baseToY: (x) => x / c,
        );

  UnitRule.mappingTable({
    required Map<String, String> mapping,
    required String unitCode,
  }) : this.plain(
          xToBase: (x, {params}) => mapping[unitCode] == x.raw ? x : null,
          baseToY: (x, {params}) => ValueModel.any(mapping[unitCode]),
        );
}
