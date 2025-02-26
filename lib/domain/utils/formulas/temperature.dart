import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/formula.dart';

final Map<String, ConvertouchFormula<double, double>> temperatureFormulas = {
  UnitCodes.degreeCelsius: ConvertouchFormula.identity<double>(),
  UnitCodes.degreeFahrenheit: ConvertouchFormula<double, double>.withoutParams(
    forward: (f) => 5.0 / 9 * (f - 32), // fahrenheit -> celsius
    reverse: (c) => 9.0 / 5 * c + 32, // celsius -> fahrenheit
    forwardStr: "C = (F - 32) · 5/9",
    reverseStr: "F = C · 9/5 + 32",
  ),
  UnitCodes.degreeKelvin: ConvertouchFormula<double, double>.withoutParams(
    forward: (k) => k - 273.15,
    reverse: (c) => c + 273.15,
    forwardStr: "C = K - 273.15",
    reverseStr: "K = C + 273.15",
  ),
  UnitCodes.degreeRankine: ConvertouchFormula<double, double>.withoutParams(
    forward: (r) => 5.0 / 9 * (r - 491.67),
    reverse: (c) => 9.0 / 5 * c + 491.67,
    forwardStr: "C = (R - 491.67) · 5/9",
    reverseStr: "R = C · 9/5 + 491.67",
  ),
  UnitCodes.degreeDelisle: ConvertouchFormula<double, double>.withoutParams(
    forward: (d) => 100 - d * 2.0 / 3,
    reverse: (c) => (100 - c) * 3.0 / 2,
    forwardStr: "C = 100 - De · 2/3",
    reverseStr: "De = (100 - C) · 1.5",
  ),
  UnitCodes.degreeNewton: ConvertouchFormula<double, double>.withoutParams(
    forward: (n) => n * 100.0 / 33,
    reverse: (c) => c * 33.0 / 100,
    forwardStr: "C = N · 100/33",
    reverseStr: "N = C · 0.33",
  ),
  UnitCodes.degreeReaumur: ConvertouchFormula<double, double>.withoutParams(
    forward: (re) => 5.0 / 4 * re,
    reverse: (c) => 4.0 / 5 * c,
    forwardStr: "C = Ré · 1.25",
    reverseStr: "Ré = C · 0.8",
  ),
  UnitCodes.degreeRomer: ConvertouchFormula<double, double>.withoutParams(
    forward: (ro) => (ro - 7.5) * 40.0 / 21,
    reverse: (c) => c * 21.0 / 40 + 7.5,
    forwardStr: "C = (Rø - 7.5) · 40/21",
    reverseStr: "Rø = C · 21/40 + 7.5",
  ),
};
