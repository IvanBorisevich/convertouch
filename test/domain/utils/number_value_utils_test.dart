import 'package:convertouch/domain/utils/number_value_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Format to scientific notation', () {
    test(
      'Values with exponent [-3..5] should not be formatted to scientific',
      () {
        expect(NumberValueUtils.formatValueInScientificNotation(1.236236478785),
            "1.236");
        expect(NumberValueUtils.formatValueInScientificNotation(1.236736478785),
            "1.237");
        expect(
            NumberValueUtils.formatValueInScientificNotation(10000), "10000");
        expect(
            NumberValueUtils.formatValueInScientificNotation(99999), "99999");
        expect(
            NumberValueUtils.formatValueInScientificNotation(0.001), "0.001");
        expect(NumberValueUtils.formatValueInScientificNotation(0.00980665),
            "0.01");
        expect(NumberValueUtils.formatValueInScientificNotation(0.9999), "1");
      },
    );

    test('Values with exponent <= -4 should be formatted', () {
      expect(NumberValueUtils.formatValueInScientificNotation(-1E-4),
          "-10¯\u2074");
      expect(NumberValueUtils.formatValueInScientificNotation(-0.0001),
          "-10¯\u2074");
      expect(NumberValueUtils.formatValueInScientificNotation(-1E-7), "-10¯⁷");
      expect(NumberValueUtils.formatValueInScientificNotation(-0.0000001),
          "-10¯⁷");
      expect(NumberValueUtils.formatValueInScientificNotation(-0.000013),
          "-1.3 · 10¯⁵");
      expect(NumberValueUtils.formatValueInScientificNotation(-0.0000323),
          "-3.23 · 10¯⁵");
      expect(NumberValueUtils.formatValueInScientificNotation(0.0000017),
          "1.7 · 10¯\u2076");
      expect(NumberValueUtils.formatValueInScientificNotation(0.00000178),
          "1.78 · 10¯\u2076");
      expect(NumberValueUtils.formatValueInScientificNotation(0.000001781),
          "1.78 · 10¯\u2076");
      expect(NumberValueUtils.formatValueInScientificNotation(0.000001785),
          "1.79 · 10¯\u2076");
      expect(NumberValueUtils.formatValueInScientificNotation(-0.0000017),
          "-1.7 · 10¯\u2076");
      expect(NumberValueUtils.formatValueInScientificNotation(-0.00000178),
          "-1.78 · 10¯\u2076");
      expect(NumberValueUtils.formatValueInScientificNotation(-0.000001781),
          "-1.78 · 10¯\u2076");
      expect(NumberValueUtils.formatValueInScientificNotation(-0.000001785),
          "-1.79 · 10¯\u2076");
      expect(NumberValueUtils.formatValueInScientificNotation(0.00000003),
          "3 · 10¯\u2078");
      expect(NumberValueUtils.formatValueInScientificNotation(0.000000003),
          "3 · 10¯\u2079");
      expect(NumberValueUtils.formatValueInScientificNotation(0.000000001),
          "10¯\u2079");
      expect(NumberValueUtils.formatValueInScientificNotation(4E-23),
          "4 · 10¯\u00B2\u00B3");
    });

    test('Values with exponent > 5 should be formatted', () {
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
      expect(NumberValueUtils.formatValue(0.5674634563478567348577), "0.567");
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
      expect(
        NumberValueUtils.formatValue(
          0.001,
        ),
        "0.001",
      );
      expect(
        NumberValueUtils.formatValue(
          0.001000000000000002,
        ),
        "0.001",
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
