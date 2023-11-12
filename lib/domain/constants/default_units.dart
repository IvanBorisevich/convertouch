const currencyGroup = "Currency";

const temperatureGroup = "Temperature";
const degreeCelsius = "Degree Celsius";
const degreeFahrenheit = "Degree Fahrenheit";
const degreeKelvin = "Degree Kelvin";
const degreeRankine = "Degree Rankine";
const degreeDelisle = "Degree Delisle";
const degreeNewton = "Degree Newton";
const degreeReaumur = "Degree Réaumur";
const degreeRomer = "Degree Rømer";


const unitDataVersions = [
  unitsV1,
];

const unitsV1 = [
  {
    "groupName": "Length",
    "units": [
      {"abbreviation": "mm", "name": "Millimeter", "coefficient": 0.001},
      {"abbreviation": "cm", "name": "Centimeter", "coefficient": 0.01},
      {"abbreviation": "dm", "name": "Decimeter", "coefficient": 0.1},
      {"abbreviation": "m", "name": "Meter", "coefficient": 1},
      {"abbreviation": "km", "name": "Kilometer", "coefficient": 1000},
      {"abbreviation": "ft", "name": "Foot (')", "coefficient": 0.3048},
      {"abbreviation": "in", "name": "Inch (\")", "coefficient": 25.4E-3},
      {"abbreviation": "yd", "name": "Yard", "coefficient": 0.9144},
      {"abbreviation": "mi", "name": "Mile", "coefficient": 1609.34},
      {"abbreviation": "pc", "name": "Parsec", "coefficient": 3.086e+16},
      {"abbreviation": "ly", "name": "Light Year", "coefficient": 9.46e+15}
    ]
  },
  {
    "groupName": "Area",
    "units": [
      {"abbreviation": "mm²", "name": "Square Millimeter", "coefficient": 1E-6},
      {"abbreviation": "cm²", "name": "Square Centimeter", "coefficient": 1E-4},
      {"abbreviation": "dm²", "name": "Square Decimeter", "coefficient": 0.01},
      {"abbreviation": "m²", "name": "Square Meter", "coefficient": 1}
    ]
  },
  {
    "groupName": "Volume",
    "units": [
      {"abbreviation": "mm³", "name": "Cubic Millimeter", "coefficient": 1E-9},
      {"abbreviation": "cm", "name": "Cubic Centimeter", "coefficient": 1E-6},
      {
        "abbreviation": "dm³",
        "name": "Cubic Decimeter (Liter)",
        "coefficient": 1E-3
      },
      {"abbreviation": "m³", "name": "Cubic Meter", "coefficient": 1},
      {
        "abbreviation": "gal",
        "name": "Gallon USA",
        "coefficient": 3.785411784E-3
      },
      {"abbreviation": "bbls", "name": "Oil Barrel", "coefficient": 158.987E-3}
    ]
  },
  {
    "groupName": "Mass",
    "units": [
      {"abbreviation": "g", "name": "Gram", "coefficient": 0.001},
      {"abbreviation": "kg", "name": "Kilogram", "coefficient": 1},
      {"abbreviation": "T", "name": "Ton", "coefficient": 1000},
      {
        "abbreviation": "lb.",
        "name": "English Pound",
        "coefficient": 0.45359237
      },
      {"abbreviation": "oz.", "name": "Ounce", "coefficient": 0.028349523},
      {"abbreviation": "ct", "name": "Carat", "coefficient": 0.0002}
    ]
  },
  {
    "groupName": temperatureGroup,
    "units": [
      {"abbreviation": "°C", "name": degreeCelsius},
      {"abbreviation": "°F", "name": degreeFahrenheit},
      {"abbreviation": "K", "name": degreeKelvin},
      {"abbreviation": "°R", "name": degreeRankine},
      {"abbreviation": "°De", "name": degreeDelisle},
      {"abbreviation": "°N", "name": degreeNewton},
      {"abbreviation": "°Ré", "name": degreeReaumur},
      {"abbreviation": "°Rø", "name": degreeRomer},
    ]
  },
  {
    "groupName": currencyGroup,
    "units": [
      {"abbreviation": "\$", "name": "Dollar USA (USD)"},
      {"abbreviation": "BYN", "name": "Ruble Belarus (BYN)"},
      {"abbreviation": "€", "name": "Euro (EUR)"}
    ]
  }
];
