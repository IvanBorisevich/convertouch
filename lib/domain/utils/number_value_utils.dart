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

class NumberValueUtils {
  static const int defaultFractionDigitsNum = 3;

  const NumberValueUtils._();

  static String formatValueScientific(
    double? value, {
    int fractionDigits = defaultFractionDigitsNum,
    int fractionDigitsInScientificNotation = 2,
    int noFormatExponentMin = -defaultFractionDigitsNum,
    int noFormatExponentMax = 5,
    String noValueStr = "",
  }) {
    if (value == null) {
      return noValueStr;
    }
    String valueStr =
        value.toStringAsExponential(fractionDigitsInScientificNotation);
    RegExpMatch? match = _scientificNotationRegexp.firstMatch(valueStr);

    if (match != null) {
      String baseSign = match.group(1)!;
      String baseStr = match.group(2)!;
      String exponentStr = match.group(3)!;

      double baseNum = double.parse(baseStr);
      double exponentNum = double.parse(exponentStr);

      if (exponentNum >= noFormatExponentMin &&
          exponentNum <= noFormatExponentMax) {
        return formatValue(
          value,
          fractionDigits: fractionDigits,
        );
      }

      String superscriptExponentStr = exponentStr.runes
          .map((code) => _exponentSuperscripts[String.fromCharCode(code)]!)
          .join();
      String result = "${10}$superscriptExponentStr";

      if (baseNum.abs() != 1) {
        String basePart = formatValue(
          baseNum.abs(),
          fractionDigits: fractionDigitsInScientificNotation,
        );
        result = "$baseSign$basePart · $result";
      } else {
        result = "$baseSign$result";
      }

      return result;
    }

    return formatValue(
      value,
      fractionDigits: fractionDigits,
    );
  }

  static String formatValue(
    double? value, {
    int fractionDigits = defaultFractionDigitsNum,
  }) {
    if (value == null) {
      return "";
    }
    if (value == 0 && value.isNegative) {
      return "0";
    }
    if (fractionDigits < 0) {
      fractionDigits = 0;
    }
    String valueStr = value.toStringAsFixed(
      value.truncateToDouble() == value ? 0 : fractionDigits,
    );

    return _trimTrailingZerosInDouble(valueStr);
  }

  static bool areEqual(
    double? num1,
    double? num2, {
    int fractionDigits = defaultFractionDigitsNum,
  }) {
    return formatValue(
          num1,
          fractionDigits: fractionDigits,
        ) ==
        formatValue(
          num2,
          fractionDigits: fractionDigits,
        );
  }

  static bool areNotEqual(
    double? num1,
    double? num2, {
    int fractionDigits = defaultFractionDigitsNum,
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
