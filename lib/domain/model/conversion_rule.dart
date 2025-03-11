import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_values_model.dart';
import 'package:convertouch/domain/model/value_model.dart';

class ConversionRule {
  final FunctionWithOptionalParams? toBase;
  final FunctionWithOptionalParams? fromBase;
  final String? toBaseStr;
  final String? fromBaseStr;

  const ConversionRule({
    required this.toBase,
    required this.fromBase,
    this.toBaseStr,
    this.fromBaseStr,
  });

  ConversionRule.withParams({
    required FunctionWithParams? toBase,
    required FunctionWithParams? fromBase,
    String? toBaseStr,
    String? fromBaseStr,
  }) : this(
          toBase: toBase != null
              ? (x, {ConversionParamSetValuesModel? params}) =>
                  toBase.call(x, params!)
              : null,
          fromBase: fromBase != null
              ? (y, {ConversionParamSetValuesModel? params}) =>
                  fromBase.call(y, params!)
              : null,
          toBaseStr: toBaseStr,
          fromBaseStr: fromBaseStr,
        );

  ConversionRule.noParams({
    required FunctionWithoutParams? toBase,
    required FunctionWithoutParams? fromBase,
    String? toBaseStr,
    String? fromBaseStr,
  }) : this(
          toBase: toBase != null
              ? (x, {ConversionParamSetValuesModel? params}) => toBase.call(x)
              : null,
          fromBase: fromBase != null
              ? (y, {ConversionParamSetValuesModel? params}) => fromBase.call(y)
              : null,
          toBaseStr: toBaseStr,
          fromBaseStr: fromBaseStr,
        );

  ConversionRule.num({
    required double Function(double)? toBase,
    required double Function(double)? fromBase,
    String? toBaseStr,
    String? fromBaseStr,
  }) : this(
          toBase: toBase != null
              ? (x, {ConversionParamSetValuesModel? params}) =>
                  ValueModel.numeric(toBase.call(x.numVal!))
              : null,
          fromBase: fromBase != null
              ? (y, {ConversionParamSetValuesModel? params}) =>
                  ValueModel.numeric(fromBase.call(y.numVal!))
              : null,
          toBaseStr: toBaseStr,
          fromBaseStr: fromBaseStr,
        );

  static ConversionRule identity() {
    return const ConversionRule(
      toBase: _identityFunc,
      fromBase: _identityFunc,
      toBaseStr: baseUnitConversionRule,
      fromBaseStr: baseUnitConversionRule,
    );
  }

  static ConversionRule fromCoefficient(double c) {
    return ConversionRule(
      toBase: (x, {ConversionParamSetValuesModel? params}) =>
          ValueModel.numeric(x.numVal! * c),
      fromBase: (y, {ConversionParamSetValuesModel? params}) =>
          ValueModel.numeric(y.numVal! / c),
    );
  }
}

ValueModel _identityFunc(
  ValueModel x, {
  ConversionParamSetValuesModel? params,
}) {
  return x;
}

typedef FormulasMap = Map<String, Map<String, ConversionRule>>;
typedef FunctionWithParams = ValueModel Function(
    ValueModel, ConversionParamSetValuesModel params);
typedef FunctionWithOptionalParams = ValueModel Function(ValueModel,
    {ConversionParamSetValuesModel? params});
typedef FunctionWithoutParams = ValueModel Function(ValueModel);
