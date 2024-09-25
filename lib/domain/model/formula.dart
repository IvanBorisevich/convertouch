import 'package:convertouch/domain/constants/constants.dart';

class ConvertouchFormula {
  final double Function(double) forward;
  final double Function(double) reverse;
  final String? forwardStr;
  final String? reverseStr;

  const ConvertouchFormula({
    required this.forward,
    required this.reverse,
    this.forwardStr,
    this.reverseStr,
  });

  double? applyForward(double? x) {
    return x != null ? forward.call(x) : null;
  }

  double? applyReverse(double? y) {
    return y != null ? reverse.call(y) : null;
  }
}

typedef FormulasMap = Map<String, Map<String, ConvertouchFormula>>;

double _identityFunc(double x) => x;

const ConvertouchFormula identity = ConvertouchFormula(
  forward: _identityFunc,
  reverse: _identityFunc,
  forwardStr: baseUnitConversionRule,
  reverseStr: baseUnitConversionRule,
);
