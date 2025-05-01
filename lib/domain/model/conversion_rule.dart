import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
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
              ? (x, {ConversionParamSetValueModel? params}) =>
                  toBase.call(x, params!)
              : null,
          fromBase: fromBase != null
              ? (y, {ConversionParamSetValueModel? params}) =>
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
              ? (x, {ConversionParamSetValueModel? params}) => toBase.call(x)
              : null,
          fromBase: fromBase != null
              ? (y, {ConversionParamSetValueModel? params}) => fromBase.call(y)
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
              ? (x, {ConversionParamSetValueModel? params}) =>
                  ValueModel.numeric(toBase.call(x.numVal!))
              : null,
          fromBase: fromBase != null
              ? (y, {ConversionParamSetValueModel? params}) =>
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

  static ConversionRule byCoefficient(double c) {
    return ConversionRule(
      toBase: (x, {ConversionParamSetValueModel? params}) =>
          ValueModel.numeric(x.numVal! * c),
      fromBase: (y, {ConversionParamSetValueModel? params}) =>
          ValueModel.numeric(y.numVal! / c),
    );
  }
}

ValueModel _identityFunc(
  ValueModel x, {
  ConversionParamSetValueModel? params,
}) {
  return x;
}

typedef FormulasMap = Map<String, Map<String, ConversionRule>>;
typedef FunctionWithParams = ValueModel? Function(
    ValueModel, ConversionParamSetValueModel params);
typedef FunctionWithOptionalParams = ValueModel? Function(ValueModel,
    {ConversionParamSetValueModel? params});
typedef FunctionWithoutParams = ValueModel? Function(ValueModel);
