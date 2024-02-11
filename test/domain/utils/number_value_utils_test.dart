import 'package:convertouch/domain/utils/number_value_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Format to scientific notation', () {
    test('Values with exponent [-7..10] should not be formatted', () {
      expect(
        NumberValueUtils.formatValueInScientificNotation(-1E-7),
        "0",
      );
      expect(NumberValueUtils.formatValueInScientificNotation(-0.000013),
          "-0.00001");
      expect(NumberValueUtils.formatValueInScientificNotation(-0.0000323),
          "-0.00003");
      expect(NumberValueUtils.formatValueInScientificNotation(-0.0000001), "0");
      expect(NumberValueUtils.formatValueInScientificNotation(0.0000017), "0");
      expect(NumberValueUtils.formatValueInScientificNotation(0.000005),
          "0.00001");
      expect(NumberValueUtils.formatValueInScientificNotation(1E10),
          "10000000000");
      expect(NumberValueUtils.formatValueInScientificNotation(1.236236478785),
          "1.23624");
      expect(NumberValueUtils.formatValueInScientificNotation(1236236.478785),
          "1236236.47879");
    });

    test('Values with exponent < -7 should be formatted', () {
      expect(NumberValueUtils.formatValueInScientificNotation(-1E-8),
          "-10¯\u2078");
      expect(NumberValueUtils.formatValueInScientificNotation(-0.00000001),
          "-10¯\u2078");
      expect(NumberValueUtils.formatValueInScientificNotation(0.00000003),
          "3 · 10¯\u2078");
      expect(NumberValueUtils.formatValueInScientificNotation(0.000000003),
          "3 · 10¯\u2079");
      expect(NumberValueUtils.formatValueInScientificNotation(0.000000001),
          "10¯\u2079");
      expect(NumberValueUtils.formatValueInScientificNotation(4E-23),
          "4 · 10¯\u00B2\u00B3");
    });

    test('Values with exponent > 10 should be formatted', () {
      expect(NumberValueUtils.formatValueInScientificNotation(1E21),
          "10\u00B2\u00B9");
      expect(NumberValueUtils.formatValueInScientificNotation(123E15),
          "1.23 · 10\u00B9\u2077");
      expect(NumberValueUtils.formatValueInScientificNotation(123E21),
          "1.23 · 10\u00B2\u00B3");
    });

    test('Value 0 should not be formatted', () {
      expect(NumberValueUtils.formatValueInScientificNotation(0), "0");
    });

    test('Value 1 should not be formatted', () {
      expect(NumberValueUtils.formatValueInScientificNotation(1), "1");
    });

    test('Value null should be formatted to the empty string', () {
      expect(NumberValueUtils.formatValueInScientificNotation(null), "");
    });
  });

  group("Format to regular string", () {
    test('Fraction digits should be trimmed by default parameter', () {
      expect(NumberValueUtils.formatValue(0.5674634563478567348577), "0.56746");
      expect(
          NumberValueUtils.formatValue(56746345631111.000), "56746345631111");
      expect(NumberValueUtils.formatValue(1.0), "1");
    });

    test('Value null should be formatted to the empty string', () {
      expect(NumberValueUtils.formatValue(null), "");
    });

    test('Fraction digits should be trimmed by explicit parameter', () {
      expect(
        NumberValueUtils.formatValue(
          0.56746,
          fractionDigits: 5,
        ),
        "0.56746",
      );
      expect(
        NumberValueUtils.formatValue(
          5674634563.0012,
          fractionDigits: 3,
        ),
        "5674634563.001",
      );
    });

    test('Fraction trailing zeros should always be trimmed', () {
      expect(
        NumberValueUtils.formatValue(
          35.0000000,
          fractionDigits: 5,
        ),
        "35",
      );
      expect(NumberValueUtils.formatValue(35.0000000), "35");
      expect(NumberValueUtils.formatValue(1.056000), "1.056");
      expect(NumberValueUtils.formatValue(1.0), "1");
    });
  });
}
