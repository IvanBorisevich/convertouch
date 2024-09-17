import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Format to scientific notation', () {
    test(
      'Values with exponent [-3..5] should not be formatted to scientific',
      () {
        expect(DoubleValueUtils.formatValueScientific(1.236236478785),
            "1.236");
        expect(DoubleValueUtils.formatValueScientific(1.236736478785),
            "1.237");
        expect(
            DoubleValueUtils.formatValueScientific(10000), "10000");
        expect(
            DoubleValueUtils.formatValueScientific(99999), "99999");
        expect(
            DoubleValueUtils.formatValueScientific(0.001), "0.001");
        expect(DoubleValueUtils.formatValueScientific(0.00980665),
            "0.01");
        expect(DoubleValueUtils.formatValueScientific(0.9999), "1");
      },
    );

    test('Values with exponent <= -4 should be formatted', () {
      expect(DoubleValueUtils.formatValueScientific(-1E-4),
          "-10¯\u2074");
      expect(DoubleValueUtils.formatValueScientific(-0.0001),
          "-10¯\u2074");
      expect(DoubleValueUtils.formatValueScientific(-1E-7), "-10¯⁷");
      expect(DoubleValueUtils.formatValueScientific(-0.0000001),
          "-10¯⁷");
      expect(DoubleValueUtils.formatValueScientific(-0.000013),
          "-1.3 · 10¯⁵");
      expect(DoubleValueUtils.formatValueScientific(-0.0000323),
          "-3.23 · 10¯⁵");
      expect(DoubleValueUtils.formatValueScientific(0.0000017),
          "1.7 · 10¯\u2076");
      expect(DoubleValueUtils.formatValueScientific(0.00000178),
          "1.78 · 10¯\u2076");
      expect(DoubleValueUtils.formatValueScientific(0.000001781),
          "1.78 · 10¯\u2076");
      expect(DoubleValueUtils.formatValueScientific(0.000001785),
          "1.79 · 10¯\u2076");
      expect(DoubleValueUtils.formatValueScientific(-0.0000017),
          "-1.7 · 10¯\u2076");
      expect(DoubleValueUtils.formatValueScientific(-0.00000178),
          "-1.78 · 10¯\u2076");
      expect(DoubleValueUtils.formatValueScientific(-0.000001781),
          "-1.78 · 10¯\u2076");
      expect(DoubleValueUtils.formatValueScientific(-0.000001785),
          "-1.79 · 10¯\u2076");
      expect(DoubleValueUtils.formatValueScientific(0.00000003),
          "3 · 10¯\u2078");
      expect(DoubleValueUtils.formatValueScientific(0.000000003),
          "3 · 10¯\u2079");
      expect(DoubleValueUtils.formatValueScientific(0.000000001),
          "10¯\u2079");
      expect(DoubleValueUtils.formatValueScientific(4E-23),
          "4 · 10¯\u00B2\u00B3");
    });

    test('Values with exponent > 5 should be formatted', () {
      expect(DoubleValueUtils.formatValueScientific(1E21),
          "10\u00B2\u00B9");
      expect(DoubleValueUtils.formatValueScientific(123E15),
          "1.23 · 10\u00B9\u2077");
      expect(DoubleValueUtils.formatValueScientific(123E21),
          "1.23 · 10\u00B2\u00B3");
    });

    test('Value 0 should not be formatted', () {
      expect(DoubleValueUtils.formatValueScientific(0), "0");
    });

    test('Value 1 should not be formatted', () {
      expect(DoubleValueUtils.formatValueScientific(1), "1");
    });

    test('Value null should be formatted to the empty string', () {
      expect(DoubleValueUtils.formatValueScientific(null), "");
    });
  });

  group("Format to regular string", () {
    test('Fraction digits should be trimmed by default parameter', () {
      expect(DoubleValueUtils.formatValue(0.5674634563478567348577), "0.567");
      expect(
          DoubleValueUtils.formatValue(56746345631111.000), "56746345631111");
      expect(DoubleValueUtils.formatValue(1.0), "1");
    });

    test('Value null should be formatted to the empty string', () {
      expect(DoubleValueUtils.formatValue(null), "");
    });

    test('Fraction digits should be trimmed by explicit parameter', () {
      expect(
        DoubleValueUtils.formatValue(
          0.56746,
          fractionDigits: 5,
        ),
        "0.56746",
      );
      expect(
        DoubleValueUtils.formatValue(
          5674634563.0012,
          fractionDigits: 3,
        ),
        "5674634563.001",
      );
      expect(
        DoubleValueUtils.formatValue(
          0.001,
        ),
        "0.001",
      );
      expect(
        DoubleValueUtils.formatValue(
          0.001000000000000002,
        ),
        "0.001",
      );
    });

    test('Fraction trailing zeros should always be trimmed', () {
      expect(
        DoubleValueUtils.formatValue(
          35.0000000,
          fractionDigits: 5,
        ),
        "35",
      );
      expect(DoubleValueUtils.formatValue(35.0000000), "35");
      expect(DoubleValueUtils.formatValue(1.056000), "1.056");
      expect(DoubleValueUtils.formatValue(1.0), "1");
    });
  });

  group('Check if a value is between two values', () {
    test('Positive cases', () {
      expect(
        DoubleValueUtils.between(
          value: 1,
          min: 0,
          max: 2,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: -1,
          min: -2,
          max: 0,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: 0,
          min: 0,
          max: 0,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: 0.0,
          min: 0.0,
          max: 0.0,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: 0.0,
          min: -0.0,
          max: 0.0,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: 0.0,
          min: 0.0,
          max: -0.0,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: 0.0,
          min: -0.0,
          max: -0.0,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: -0.0,
          min: -0.0,
          max: -0.0,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: -0.0,
          min: 0.0,
          max: 0.1,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: 123,
          min: null,
          max: null,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: 123,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: double.negativeInfinity,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: double.infinity,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: null,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: null,
          min: 1,
          max: 3,
        ),
        true,
      );
      expect(
        DoubleValueUtils.between(
          value: null,
          min: 1000,
          max: 3,
        ),
        true,
      );
    });

    test('Negative cases', () {
      expect(
        DoubleValueUtils.between(
          value: 1,
          min: 2,
          max: 1,
        ),
        false,
      );
      expect(
        DoubleValueUtils.between(
          value: 1,
          min: 5,
          max: 8,
        ),
        false,
      );
      expect(
        DoubleValueUtils.between(
          value: -0.5,
          min: 0,
        ),
        false,
      );
      expect(
        DoubleValueUtils.between(
          value: double.nan,
        ),
        false,
      );
      expect(
        DoubleValueUtils.between(
          value: double.nan,
          min: 2,
          max: 3,
        ),
        false,
      );
      expect(
        DoubleValueUtils.between(
          value: double.infinity,
          min: 1,
          max: 3,
        ),
        false,
      );
      expect(
        DoubleValueUtils.between(
          value: double.negativeInfinity,
          min: 1,
          max: 3,
        ),
        false,
      );
    });
  });
}
