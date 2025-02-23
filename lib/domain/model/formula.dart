import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_values_model.dart';

class ConvertouchFormula<X, Y> {
  final Y Function(X, {ConversionParamSetValuesModel? params}) forward;
  final X Function(Y, {ConversionParamSetValuesModel? params}) reverse;
  final String? forwardStr;
  final String? reverseStr;

  const ConvertouchFormula({
    required this.forward,
    required this.reverse,
    this.forwardStr,
    this.reverseStr,
  });

  ConvertouchFormula.withParams({
    required Y Function(X, ConversionParamSetValuesModel params) forward,
    required X Function(Y, ConversionParamSetValuesModel params) reverse,
    String? forwardStr,
    String? reverseStr,
  }) : this(
          forward: (x, {ConversionParamSetValuesModel? params}) =>
              forward.call(x, params!),
          reverse: (y, {ConversionParamSetValuesModel? params}) =>
              reverse.call(y, params!),
          forwardStr: forwardStr,
          reverseStr: reverseStr,
        );

  ConvertouchFormula.withoutParams({
    required Y Function(X) forward,
    required X Function(Y) reverse,
    String? forwardStr,
    String? reverseStr,
  }) : this(
          forward: (x, {ConversionParamSetValuesModel? params}) =>
              forward.call(x),
          reverse: (y, {ConversionParamSetValuesModel? params}) =>
              reverse.call(y),
          forwardStr: forwardStr,
          reverseStr: reverseStr,
        );

  Y? applyForward(X? x, {ConversionParamSetValuesModel? params}) {
    return x != null ? forward.call(x, params: params) : null;
  }

  X? applyReverse(Y? y, {ConversionParamSetValuesModel? params}) {
    return y != null ? reverse.call(y, params: params) : null;
  }

  static identity<T>() {
    return ConvertouchFormula<T, T>(
      forward: _identityFunc<T>,
      reverse: _identityFunc<T>,
      forwardStr: baseUnitConversionRule,
      reverseStr: baseUnitConversionRule,
    );
  }
}

typedef FormulasMap = Map<String, Map<String, ConvertouchFormula>>;

X _identityFunc<X>(X x, {ConversionParamSetValuesModel? params}) => x;
