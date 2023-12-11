import 'package:convertouch/domain/constants/default_units.dart';
import 'package:convertouch/domain/model/formula.dart';

ConvertouchFormula getFormula(String unitGroupName, String unitName) {
  var formula = formulasMap[unitGroupName]?[unitName];
  if (formula == null) {
    throw Exception(
      "Formula not found for unit group $unitGroupName and unit $unitName",
    );
  }
  return formula;
}

final FormulasMap formulasMap = {
  temperatureGroup: {
    degreeCelsius: identity,
    degreeFahrenheit: ConvertouchFormula(
      forward: (f) => 5.0 / 9 * (f - 32), // fahrenheit -> celsius
      reverse: (c) => 9.0 / 5 * c + 32, // celsius -> fahrenheit
    ),
    degreeKelvin: ConvertouchFormula(
      forward: (k) => k - 273.15,
      reverse: (c) => c + 273.15,
    ),
    degreeRankine: ConvertouchFormula(
      forward: (r) => 5.0 / 9 * (r - 491.67),
      reverse: (c) => 9.0 / 5 * c + 491.67,
    ),
    degreeDelisle: ConvertouchFormula(
      forward: (d) => 100 - d * 2.0 / 3,
      reverse: (c) => (100 - c) * 3.0 / 2,
    ),
    degreeNewton: ConvertouchFormula(
      forward: (n) => n * 100.0 / 33,
      reverse: (c) => c * 33.0 / 100,
    ),
    degreeReaumur: ConvertouchFormula(
      forward: (re) => 5.0 / 4 * re,
      reverse: (c) => 4.0 / 5 * c,
    ),
    degreeRomer: ConvertouchFormula(
      forward: (ro) => (ro - 7.5) * 40.0 / 21,
      reverse: (c) => c * 21.0 / 40 + 7.5,
    ),
  },
};
