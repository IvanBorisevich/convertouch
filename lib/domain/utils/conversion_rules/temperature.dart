import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';

final Map<String, UnitRule> temperatureRules = {
  UnitCodes.degreeCelsius: UnitRule.identity,
  UnitCodes.degreeFahrenheit: UnitRule.num(
    xToBase: (f) => 5.0 / 9 * (f - 32), // fahrenheit -> celsius
    baseToY: (c) => 9.0 / 5 * c + 32, // celsius -> fahrenheit
    xToBaseStr: "C = (F - 32) · 5/9",
    baseToYStr: "F = C · 9/5 + 32",
  ),
  UnitCodes.degreeKelvin: UnitRule.num(
    xToBase: (k) => k - 273.15,
    baseToY: (c) => c + 273.15,
    xToBaseStr: "C = K - 273.15",
    baseToYStr: "K = C + 273.15",
  ),
  UnitCodes.degreeRankine: UnitRule.num(
    xToBase: (r) => 5.0 / 9 * (r - 491.67),
    baseToY: (c) => 9.0 / 5 * c + 491.67,
    xToBaseStr: "C = (R - 491.67) · 5/9",
    baseToYStr: "R = C · 9/5 + 491.67",
  ),
  UnitCodes.degreeDelisle: UnitRule.num(
    xToBase: (d) => 100 - d * 2.0 / 3,
    baseToY: (c) => (100 - c) * 3.0 / 2,
    xToBaseStr: "C = 100 - De · 2/3",
    baseToYStr: "De = (100 - C) · 1.5",
  ),
  UnitCodes.degreeNewton: UnitRule.num(
    xToBase: (n) => n * 100.0 / 33,
    baseToY: (c) => c * 33.0 / 100,
    xToBaseStr: "C = N · 100/33",
    baseToYStr: "N = C · 0.33",
  ),
  UnitCodes.degreeReaumur: UnitRule.num(
    xToBase: (re) => 5.0 / 4 * re,
    baseToY: (c) => 4.0 / 5 * c,
    xToBaseStr: "C = Ré · 1.25",
    baseToYStr: "Ré = C · 0.8",
  ),
  UnitCodes.degreeRomer: UnitRule.num(
    xToBase: (ro) => (ro - 7.5) * 40.0 / 21,
    baseToY: (c) => c * 21.0 / 40 + 7.5,
    xToBaseStr: "C = (Rø - 7.5) · 40/21",
    baseToYStr: "Rø = C · 21/40 + 7.5",
  ),
};
