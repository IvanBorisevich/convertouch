import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Format to scientific notation', () {
    test(
      'Values with exponent [-3..5] should not be formatted to scientific',
      () {
        expect(DoubleValueUtils.formatScientific(1.236236478785),
            "1.236");
        expect(DoubleValueUtils.formatScientific(1.236736478785),
            "1.237");
        expect(
            DoubleValueUtils.formatScientific(10000), "10000");
        expect(
            DoubleValueUtils.formatScientific(99999), "99999");
        expect(
            DoubleValueUtils.formatScientific(0.001), "0.001");
        expect(DoubleValueUtils.formatScientific(0.00980665),
            "0.01");
        expect(DoubleValueUtils.formatScientific(0.9999), "1");
      },
    );

    test('Values with exponent <= -4 should be formatted', () {
      expect(DoubleValueUtils.formatScientific(-1E-4),
          "-10¯\u2074");
      expect(DoubleValueUtils.formatScientific(-0.0001),
          "-10¯\u2074");
      expect(DoubleValueUtils.formatScientific(-1E-7), "-10¯⁷");
      expect(DoubleValueUtils.formatScientific(-0.0000001),
          "-10¯⁷");
      expect(DoubleValueUtils.formatScientific(-0.000013),
          "-1.3 · 10¯⁵");
      expect(DoubleValueUtils.formatScientific(-0.0000323),
          "-3.23 · 10¯⁵");
      expect(DoubleValueUtils.formatScientific(0.0000017),
          "1.7 · 10¯\u2076");
      expect(DoubleValueUtils.formatScientific(0.00000178),
          "1.78 · 10¯\u2076");
      expect(DoubleValueUtils.formatScientific(0.000001781),
          "1.78 · 10¯\u2076");
      expect(DoubleValueUtils.formatScientific(0.000001785),
          "1.79 · 10¯\u2076");
      expect(DoubleValueUtils.formatScientific(-0.0000017),
          "-1.7 · 10¯\u2076");
      expect(DoubleValueUtils.formatScientific(-0.00000178),
          "-1.78 · 10¯\u2076");
      expect(DoubleValueUtils.formatScientific(-0.000001781),
          "-1.78 · 10¯\u2076");
      expect(DoubleValueUtils.formatScientific(-0.000001785),
          "-1.79 · 10¯\u2076");
      expect(DoubleValueUtils.formatScientific(0.00000003),
          "3 · 10¯\u2078");
      expect(DoubleValueUtils.formatScientific(0.000000003),
          "3 · 10¯\u2079");
      expect(DoubleValueUtils.formatScientific(0.000000001),
          "10¯\u2079");
      expect(DoubleValueUtils.formatScientific(4E-23),
          "4 · 10¯\u00B2\u00B3");
    });

    test('Values with exponent > 5 should be formatted', () {
      expect(DoubleValueUtils.formatScientific(1E21),
          "10\u00B2\u00B9");
      expect(DoubleValueUtils.formatScientific(123E15),
          "1.23 · 10\u00B9\u2077");
      expect(DoubleValueUtils.formatScientific(123E21),
          "1.23 · 10\u00B2\u00B3");
    });

    test('Value 0 should not be formatted', () {
      expect(DoubleValueUtils.formatScientific(0), "0");
    });

    test('Value 1 should not be formatted', () {
      expect(DoubleValueUtils.formatScientific(1), "1");
    });

    test('Value null should be formatted to the empty string', () {
      expect(DoubleValueUtils.formatScientific(null), "");
    });
  });

  group("Format to regular string", () {
    test('Fraction digits should be trimmed by default parameter', () {
      expect(DoubleValueUtils.format(0.5674634563478567348577), "0.567");
      expect(
          DoubleValueUtils.format(56746345631111.000), "56746345631111");
      expect(DoubleValueUtils.format(1.0), "1");
    });

    test('Value null should be formatted to the empty string', () {
      expect(DoubleValueUtils.format(null), "");
    });

    test('Fraction digits should be trimmed by explicit parameter', () {
      expect(
        DoubleValueUtils.format(
          0.56746,
          fractionDigits: 5,
        ),
        "0.56746",
      );
      expect(
        DoubleValueUtils.format(
          5674634563.0012,
          fractionDigits: 3,
        ),
        "5674634563.001",
      );
      expect(
        DoubleValueUtils.format(
          0.001,
        ),
        "0.001",
      );
      expect(
        DoubleValueUtils.format(
          0.001000000000000002,
        ),
        "0.001",
      );
    });

    test('Fraction trailing zeros should always be trimmed', () {
      expect(
        DoubleValueUtils.format(
          35.0000000,
          fractionDigits: 5,
        ),
        "35",
      );
      expect(DoubleValueUtils.format(35.0000000), "35");
      expect(DoubleValueUtils.format(1.056000), "1.056");
      expect(DoubleValueUtils.format(1.0), "1");
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
