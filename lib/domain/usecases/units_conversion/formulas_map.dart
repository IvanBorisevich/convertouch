import 'package:convertouch/domain/constants/default_units.dart';
import 'package:convertouch/domain/usecases/units_conversion/model/formula.dart';

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
    degreeCelsius: ConvertouchFormula(
      forward: (x) => x,
      reverse: (y) => y,
    ),
    degreeFahrenheit: ConvertouchFormula(
      forward: (x) => 5.0 / 9 * (x - 32), // fahrenheit -> celsius
      reverse: (y) => 9.0 / 5 * y + 32, // celsius -> fahrenheit
    ),
    degreeKelvin: ConvertouchFormula(
      forward: (x) => x - 273.15, // kelvin -> celsius
      reverse: (y) => y + 273.15, // celsius -> kelvin
    ),
  },
};
