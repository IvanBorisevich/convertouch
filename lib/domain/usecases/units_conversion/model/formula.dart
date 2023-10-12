class ConvertouchFormula {
  final double Function(double) forward;
  final double Function(double) reverse;

  const ConvertouchFormula({
    required this.forward,
    required this.reverse,
  });

  double? applyForward(double? x) {
    return x != null ? forward.call(x) : null;
  }

  double? applyReverse(double? y) {
    return y != null ? reverse.call(y) : null;
  }
}

typedef FormulasMap = Map<String, Map<String, ConvertouchFormula>>;
