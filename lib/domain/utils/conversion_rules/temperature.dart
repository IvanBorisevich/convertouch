import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/utils/conversion_rule.dart';

final Map<ConversionRuleType, Map<String, ConversionRule>> temperatureRules = {
  ConversionRuleType.xToBase: _toCelsius,
  ConversionRuleType.baseToY: _fromCelsius,
};

final Map<String, ConversionRule> _toCelsius = {
  UnitCodes.degreeCelsius: ConversionRule.identity,
  UnitCodes.degreeFahrenheit: ConversionRule.numFunction(
    func: (f) => 5.0 / 9 * (f - 32),
  ),
  UnitCodes.degreeKelvin: ConversionRule.numFunction(
    func: (k) => k - 273.15,
  ),
  UnitCodes.degreeRankine: ConversionRule.numFunction(
    func: (r) => 5.0 / 9 * (r - 491.67),
  ),
  UnitCodes.degreeDelisle: ConversionRule.numFunction(
    func: (d) => 100 - d * 2.0 / 3,
  ),
  UnitCodes.degreeNewton: ConversionRule.numFunction(
    func: (n) => n * 100.0 / 33,
  ),
  UnitCodes.degreeReaumur: ConversionRule.numFunction(
    func: (re) => 5.0 / 4 * re,
  ),
  UnitCodes.degreeRomer: ConversionRule.numFunction(
    func: (ro) => (ro - 7.5) * 40.0 / 21,
  ),
};

final Map<String, ConversionRule> _fromCelsius = {
  UnitCodes.degreeCelsius: ConversionRule.identity,
  UnitCodes.degreeFahrenheit: ConversionRule.numFunction(
    func: (c) => 9.0 / 5 * c + 32,
    desc: "F = C · 9/5 + 32",
  ),
  UnitCodes.degreeKelvin: ConversionRule.numFunction(
    func: (c) => c + 273.15,
    desc: "K = C + 273.15",
  ),
  UnitCodes.degreeRankine: ConversionRule.numFunction(
    func: (c) => 9.0 / 5 * c + 491.67,
    desc: "R = C · 9/5 + 491.67",
  ),
  UnitCodes.degreeDelisle: ConversionRule.numFunction(
    func: (c) => (100 - c) * 3.0 / 2,
    desc: "De = (100 - C) · 1.5",
  ),
  UnitCodes.degreeNewton: ConversionRule.numFunction(
    func: (c) => c * 33.0 / 100,
    desc: "N = C · 0.33",
  ),
  UnitCodes.degreeReaumur: ConversionRule.numFunction(
    func: (c) => 4.0 / 5 * c,
    desc: "Ré = C · 0.8",
  ),
  UnitCodes.degreeRomer: ConversionRule.numFunction(
    func: (c) => c * 21.0 / 40 + 7.5,
    desc: "Rø = C · 21/40 + 7.5",
  ),
};
