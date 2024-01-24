import 'package:convertouch/domain/constants/constants.dart';

const currencyGroup = "Currency";
const temperatureGroup = "Temperature";
const degreeCelsiusCode = "°C";
const degreeFahrenheitCode = "°F";
const degreeKelvinCode = "K";
const degreeRankineCode = "°R";
const degreeDelisleCode = "°De";
const degreeNewtonCode = "°N";
const degreeReaumurCode = "°Ré";
const degreeRomerCode = "°Rø";


const unitDataVersions = [
  unitsV1,
];

const unitsV1 = [
  {
    "groupName": "Length",
    "units": [
      {"code": "mm", "name": "Millimeter", "coefficient": 0.001},
      {"code": "cm", "name": "Centimeter", "coefficient": 0.01},
      {"code": "dm", "name": "Decimeter", "coefficient": 0.1},
      {"code": "m", "name": "Meter", "coefficient": 1},
      {"code": "km", "name": "Kilometer", "coefficient": 1000},
      {"code": "ft", "name": "Foot", "coefficient": 0.3048, "symbol": "'"},
      {"code": "in", "name": "Inch", "coefficient": 25.4E-3, "symbol": "\""},
      {"code": "yd", "name": "Yard", "coefficient": 0.9144},
      {"code": "mi", "name": "Mile", "coefficient": 1609.34},
      {"code": "pc", "name": "Parsec", "coefficient": 3.086e+16},
      {"code": "ly", "name": "Light Year", "coefficient": 9.46e+15}
    ]
  },
  {
    "groupName": "Area",
    "units": [
      {"code": "mm²", "name": "Square Millimeter", "coefficient": 1E-6},
      {"code": "cm²", "name": "Square Centimeter", "coefficient": 1E-4},
      {"code": "dm²", "name": "Square Decimeter", "coefficient": 0.01},
      {"code": "m²", "name": "Square Meter", "coefficient": 1}
    ]
  },
  {
    "groupName": "Volume",
    "units": [
      {"code": "mm³", "name": "Cubic Millimeter", "coefficient": 1E-9},
      {"code": "cm", "name": "Cubic Centimeter", "coefficient": 1E-6},
      {
        "code": "dm³",
        "name": "Cubic Decimeter (Liter)",
        "coefficient": 1E-3
      },
      {"code": "m³", "name": "Cubic Meter", "coefficient": 1},
      {
        "code": "gal",
        "name": "Gallon USA",
        "coefficient": 3.785411784E-3
      },
      {"code": "bbls", "name": "Oil Barrel", "coefficient": 158.987E-3}
    ]
  },
  {
    "groupName": "Mass",
    "units": [
      {"code": "g", "name": "Gram", "coefficient": 0.001},
      {"code": "kg", "name": "Kilogram", "coefficient": 1},
      {"code": "T", "name": "Ton", "coefficient": 1000},
      {
        "code": "lb.",
        "name": "English Pound",
        "coefficient": 0.45359237
      },
      {"code": "oz.", "name": "Ounce", "coefficient": 0.028349523},
      {"code": "ct", "name": "Carat", "coefficient": 0.0002}
    ]
  },
  {
    "groupName": temperatureGroup,
    "conversionType": ConversionType.formula,
    "refreshable": true,
    "units": [
      {"code": degreeCelsiusCode, "name": "Degree Celsius"},
      {"code": degreeFahrenheitCode, "name": "Degree Fahrenheit"},
      {"code": degreeKelvinCode, "name": "Degree Kelvin"},
      {"code": degreeRankineCode, "name": "Degree Rankine"},
      {"code": degreeDelisleCode, "name": "Degree Delisle"},
      {"code": degreeNewtonCode, "name": "Degree Newton"},
      {"code": degreeReaumurCode, "name": "Degree Réaumur"},
      {"code": degreeRomerCode, "name": "Degree Rømer"},
    ]
  },
  {
    "groupName": currencyGroup,
    "conversionType": ConversionType.dynamic,
    "refreshable": true,
    "units": [
      {"code": "USD", "name": "Dollar USA", "coefficient": 1, "symbol": "\$"},
      {"code": "BYN", "name": "Belarusian Ruble"},
      {"code": "EUR", "name": "Euro", "symbol": "€"}
    ]
  }
];
