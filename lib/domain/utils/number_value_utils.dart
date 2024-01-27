import 'package:convertouch/domain/model/value_model.dart';

final _scientificNotationRegexp = RegExp(r"(-?)(\d\.?\d*)e[+]?(-?\d+)");
const int maxFractionDigits = 10;

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
  const NumberValueUtils._();

  static String formatValueInScientificNotation(
    double? value, {
    int fractionDigits = maxFractionDigits,
    int fractionDigitsInScientificNotation = 4,
    int noFormatExponentMin = -7,
    int noFormatExponentMax = 10,
  }) {
    if (value == null) {
      return "";
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
    int fractionDigits = maxFractionDigits,
  }) {
    if (value == null) {
      return "";
    }
    if (fractionDigits < 0) {
      fractionDigits = 0;
    }
    if (fractionDigits > maxFractionDigits) {
      fractionDigits = maxFractionDigits;
    }
    String valueStr = value.toStringAsFixed(
      value.truncateToDouble() == value ? 0 : fractionDigits,
    );

    return _trimTrailingZerosInDouble(valueStr);
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

  static ValueModel buildValueModel(double? rawValue) {
    return ValueModel(
      strValue: NumberValueUtils.formatValue(
        rawValue,
      ),
      scientificValue: NumberValueUtils.formatValueInScientificNotation(
        rawValue,
      ),
    );
  }
}
