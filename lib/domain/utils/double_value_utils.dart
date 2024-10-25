import 'package:decimal/decimal.dart';

final _scientificNotationRegexp = RegExp(r"(-?)(\d\.?\d*)e[+]?(-?\d+)");

const _exponentSuperscripts = {
  '0': '\u2070',
  '1': '\u00B9',
  '2': '\u00B2',
  '3': '\u00B3',
  '4': '\u2074',
  '5': '\u2075',
  '6': '\u2076',
  '7': '\u2077',
  '8': '\u2078',
  '9': '\u2079',
  '-': '¯',
};

class DoubleValueUtils {
  static const int defaultFractionDigits = 10;

  const DoubleValueUtils._();

  static String toScientific(
    double? value, {
    int fractionDigitsInSignificand = 2,
    int noFormatMinExponent = -4,
    int noFormatMaxExponent = 7,
    int? fractionDigitsInUnformatted,
    String defaultValue = "",
  }) {
    if (value == null) {
      return defaultValue;
    }
    String valueStr = value.toStringAsExponential(fractionDigitsInSignificand);
    RegExpMatch? match = _scientificNotationRegexp.firstMatch(valueStr);

    if (match != null) {
      String significandSign = match.group(1)!;
      String significandStr = match.group(2)!;
      String exponentStr = match.group(3)!;

      double significandNum = double.parse(significandStr);
      double exponentNum = double.parse(exponentStr);

      if (exponentNum >= noFormatMinExponent &&
          exponentNum <= noFormatMaxExponent) {
        return toPlain(
          value,
          fractionDigits: fractionDigitsInUnformatted ?? defaultFractionDigits,
        );
      }

      String superscriptExponentStr = exponentStr.runes
          .map((code) => _exponentSuperscripts[String.fromCharCode(code)]!)
          .join();
      String result = "${10}$superscriptExponentStr";

      if (significandNum.abs() != 1) {
        String basePart = toPlain(
          significandNum.abs(),
          fractionDigits: fractionDigitsInSignificand,
        );
        result = "$significandSign$basePart · $result";
      } else {
        result = "$significandSign$result";
      }

      return result;
    }

    return defaultValue;
  }

  static String toPlain(
    double? value, {
    int? fractionDigits,
  }) {
    if (value == null) {
      return "";
    }
    if (value == 0 && value.isNegative) {
      return "0";
    }

    String valueStr;
    if (fractionDigits == null) {
      valueStr = "${Decimal.parse(value.toString())}";
    } else {
      fractionDigits = fractionDigits < 0 ? 0 : fractionDigits;
      valueStr = value.toStringAsFixed(
        value.truncateToDouble() == value ? 0 : fractionDigits,
      );
    }

    return _trimTrailingZerosInDouble(valueStr);
  }

  static bool areEqual(
    double? num1,
    double? num2, {
    int fractionDigits = defaultFractionDigits,
  }) {
    return toPlain(num1, fractionDigits: fractionDigits) ==
        toPlain(num2, fractionDigits: fractionDigits);
  }

  static bool areNotEqual(
    double? num1,
    double? num2, {
    int fractionDigits = defaultFractionDigits,
  }) {
    return !areEqual(
      num1,
      num2,
      fractionDigits: fractionDigits,
    );
  }

  static bool between({
    required double? value,
    double? min,
    double? max,
  }) {
    if (value == null) {
      return true;
    }
    if (value.isNaN) {
      return false;
    }
    value = _valueOrZero(value);
    min = _valueOrZero(min ?? double.negativeInfinity);
    max = _valueOrZero(max ?? double.infinity);
    return value.compareTo(min) >= 0 && value.compareTo(max) <= 0;
  }

  static double _valueOrZero(double value) {
    return value != 0 ? value : 0;
  }

  static String _trimTrailingZerosInDouble(String doubleStr) {
    if (!doubleStr.contains('.')) {
      return doubleStr;
    }

    int index = doubleStr.length - 1;

    while (doubleStr[index] != '.') {
      if (doubleStr[index] != '0') {
        break;
      }
      index--;
    }

    if (doubleStr[index] == '.') {
      index--;
    }

    return doubleStr.substring(0, index + 1);
  }
}
