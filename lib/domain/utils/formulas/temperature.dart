import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_rule.dart';

final Map<String, ConversionRule> temperatureFormulas = {
  UnitCodes.degreeCelsius: ConversionRule.identity(),
  UnitCodes.degreeFahrenheit: ConversionRule.num(
    toBase: (f) => 5.0 / 9 * (f - 32), // fahrenheit -> celsius
    fromBase: (c) => 9.0 / 5 * c + 32, // celsius -> fahrenheit
    toBaseStr: "C = (F - 32) · 5/9",
    fromBaseStr: "F = C · 9/5 + 32",
  ),
  UnitCodes.degreeKelvin: ConversionRule.num(
    toBase: (k) => k - 273.15,
    fromBase: (c) => c + 273.15,
    toBaseStr: "C = K - 273.15",
    fromBaseStr: "K = C + 273.15",
  ),
  UnitCodes.degreeRankine: ConversionRule.num(
    toBase: (r) => 5.0 / 9 * (r - 491.67),
    fromBase: (c) => 9.0 / 5 * c + 491.67,
    toBaseStr: "C = (R - 491.67) · 5/9",
    fromBaseStr: "R = C · 9/5 + 491.67",
  ),
  UnitCodes.degreeDelisle: ConversionRule.num(
    toBase: (d) => 100 - d * 2.0 / 3,
    fromBase: (c) => (100 - c) * 3.0 / 2,
    toBaseStr: "C = 100 - De · 2/3",
    fromBaseStr: "De = (100 - C) · 1.5",
  ),
  UnitCodes.degreeNewton: ConversionRule.num(
    toBase: (n) => n * 100.0 / 33,
    fromBase: (c) => c * 33.0 / 100,
    toBaseStr: "C = N · 100/33",
    fromBaseStr: "N = C · 0.33",
  ),
  UnitCodes.degreeReaumur: ConversionRule.num(
    toBase: (re) => 5.0 / 4 * re,
    fromBase: (c) => 4.0 / 5 * c,
    toBaseStr: "C = Ré · 1.25",
    fromBaseStr: "Ré = C · 0.8",
  ),
  UnitCodes.degreeRomer: ConversionRule.num(
    toBase: (ro) => (ro - 7.5) * 40.0 / 21,
    fromBase: (c) => c * 21.0 / 40 + 7.5,
    toBaseStr: "C = (Rø - 7.5) · 40/21",
    fromBaseStr: "Rø = C · 21/40 + 7.5",
  ),
};
