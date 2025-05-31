import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Format to the string in scientific notation', () {
    test(
      'Values with exponent from -4 to 7 should not be formatted to scientific',
      () {
        expect(
          DoubleValueUtils.format(0.09999999999999999, scientific: true),
          "0.1",
        );
        expect(
          DoubleValueUtils.format(-0010000000, scientific: true),
          "-10000000",
        );
        expect(
          DoubleValueUtils.format(-10000000, scientific: true),
          "-10000000",
        );
        expect(DoubleValueUtils.format(-1000000, scientific: true), "-1000000");
        expect(
          DoubleValueUtils.format(-1.236236478785, scientific: true),
          "-1.2362364788",
        );
        expect(DoubleValueUtils.format(-1, scientific: true), "-1");
        expect(DoubleValueUtils.format(-0.9999, scientific: true), "-0.9999");
        expect(DoubleValueUtils.format(-000.9999, scientific: true), "-0.9999");
        expect(DoubleValueUtils.format(-1E-4, scientific: true), "-0.0001");
        expect(DoubleValueUtils.format(0, scientific: true), "0");
        expect(DoubleValueUtils.format(-0, scientific: true), "0");
        expect(DoubleValueUtils.format(0.001, scientific: true), "0.001");
        expect(DoubleValueUtils.format(0.0098, scientific: true), "0.0098");
        expect(
          DoubleValueUtils.format(0.00980665, scientific: true),
          "0.00980665",
        );
        expect(DoubleValueUtils.format(0.9999, scientific: true), "0.9999");
        expect(DoubleValueUtils.format(000.9999, scientific: true), "0.9999");
        expect(DoubleValueUtils.format(1, scientific: true), "1");
        expect(
          DoubleValueUtils.format(1.236236478785, scientific: true),
          "1.2362364788",
        );
        expect(DoubleValueUtils.format(1000000, scientific: true), "1000000");
        expect(DoubleValueUtils.format(10000000, scientific: true), "10000000");
        expect(
          DoubleValueUtils.format(0010000000, scientific: true),
          "10000000",
        );
      },
    );

    test('Values with exponent less than -4 should be formatted', () {
      expect(DoubleValueUtils.format(-1E-7, scientific: true), "-10¯⁷");
      expect(DoubleValueUtils.format(-0.0000001, scientific: true), "-10¯⁷");
      expect(
        DoubleValueUtils.format(-0.000013, scientific: true),
        "-1.3 · 10¯⁵",
      );
      expect(
        DoubleValueUtils.format(-0.0000323, scientific: true),
        "-3.23 · 10¯⁵",
      );
      expect(
        DoubleValueUtils.format(0.0000017, scientific: true),
        "1.7 · 10¯⁶",
      );
      expect(
        DoubleValueUtils.format(0.00000178, scientific: true),
        "1.78 · 10¯⁶",
      );
      expect(
        DoubleValueUtils.format(0.000001781, scientific: true),
        "1.78 · 10¯⁶",
      );
      expect(
        DoubleValueUtils.format(0.000001785, scientific: true),
        "1.79 · 10¯⁶",
      );
      expect(
        DoubleValueUtils.format(-0.0000017, scientific: true),
        "-1.7 · 10¯⁶",
      );
      expect(
        DoubleValueUtils.format(-0.00000178, scientific: true),
        "-1.78 · 10¯⁶",
      );
      expect(
        DoubleValueUtils.format(-0.000001781, scientific: true),
        "-1.78 · 10¯⁶",
      );
      expect(
        DoubleValueUtils.format(-0.000001785, scientific: true),
        "-1.79 · 10¯⁶",
      );
      expect(DoubleValueUtils.format(0.00000003, scientific: true), "3 · 10¯⁸");
      expect(
          DoubleValueUtils.format(0.000000003, scientific: true), "3 · 10¯⁹");
      expect(DoubleValueUtils.format(0.000000001, scientific: true), "10¯⁹");
      expect(DoubleValueUtils.format(4E-23, scientific: true), "4 · 10¯²³");
    });

    test('Values with exponent more than 7 should be formatted', () {
      expect(DoubleValueUtils.format(1E21, scientific: true), "10²¹");
      expect(DoubleValueUtils.format(123E15, scientific: true), "1.23 · 10¹⁷");
      expect(DoubleValueUtils.format(123E21, scientific: true), "1.23 · 10²³");
      expect(
        DoubleValueUtils.format(123.44E21,
            scientific: true, fractionDigitsInScientific: 3),
        "1.234 · 10²³",
      );
    });

    test('Value null should be formatted to the empty string', () {
      expect(DoubleValueUtils.format(null, scientific: true), "");
    });
  });

  group("Format to the ordinary string", () {
    test('Value null should be formatted to the empty string', () {
      expect(DoubleValueUtils.format(null), "");
    });

    test(
      'Fraction digits (<= 10) should not be trimmed',
      () {
        expect(DoubleValueUtils.format(56746345631111.000), "56746345631111");
        expect(DoubleValueUtils.format(1.0), "1");
      },
    );

    test(
      'Fraction digits (> 10) should be trimmed to 10 with possible rounding',
      () {
        expect(DoubleValueUtils.format(0.09999999999999999), "0.1");
        expect(DoubleValueUtils.format(9.999999999999999), "10");
        expect(DoubleValueUtils.format(0.00000000000000000000000001), "0");
        expect(
          DoubleValueUtils.format(0.00000000010000000000000001),
          "0.0000000001",
        );

        expect(
          double.parse(DoubleValueUtils.format(0.09999999999999999)),
          0.1,
        );
      },
    );

    test(
      '''
      Fraction digits (> 10) should be trimmed to explicit parameter
      with possible rounding
      ''',
      () {
        expect(
          DoubleValueUtils.format(
            0.00000000000000000000000001,
            fractionDigits: 12,
          ),
          "0",
        );
        expect(
          DoubleValueUtils.format(
            0.00000000000990000000000001,
            fractionDigits: 12,
          ),
          "0.00000000001",
        );
        expect(
          DoubleValueUtils.format(
            0.00000000010000000000000001,
            fractionDigits: 12,
          ),
          "0.0000000001",
        );
      },
    );

    test('Value null should be formatted to the empty string', () {
      expect(DoubleValueUtils.format(null), "");
    });

    test('Fraction digits should be trimmed by the explicit parameter', () {
      expect(DoubleValueUtils.format(0.56746, fractionDigits: 5), "0.56746");
      expect(
        DoubleValueUtils.format(5674634563.0012, fractionDigits: 3),
        "5674634563.001",
      );
      expect(DoubleValueUtils.format(0.001, fractionDigits: 8), "0.001");
      expect(
          DoubleValueUtils.format(
            0.001000000000000002,
            fractionDigits: 9,
          ),
          "0.001");
    });

    test('Fraction trailing zeros should always be trimmed', () {
      expect(DoubleValueUtils.format(35.0000000, fractionDigits: 5), "35");
      expect(DoubleValueUtils.format(0035.0000000, fractionDigits: 5), "35");
      expect(DoubleValueUtils.format(35.0000000), "35");
      expect(DoubleValueUtils.format(1.056000), "1.056");
      expect(DoubleValueUtils.format(001.056000), "1.056");
      expect(DoubleValueUtils.format(1.0), "1");
    });
  });

  group('Check if a value is between two values', () {
    test('Positive cases', () {
      expect(DoubleValueUtils.between(value: 1, min: 0, max: 2), true);
      expect(DoubleValueUtils.between(value: -1, min: -2, max: 0), true);
      expect(DoubleValueUtils.between(value: 0, min: 0, max: 0), true);
      expect(DoubleValueUtils.between(value: 0.0, min: 0.0, max: 0.0), true);
      expect(DoubleValueUtils.between(value: 0.0, min: -0.0, max: 0.0), true);
      expect(DoubleValueUtils.between(value: 0.0, min: 0.0, max: -0.0), true);
      expect(DoubleValueUtils.between(value: 0.0, min: -0.0, max: -0.0), true);
      expect(DoubleValueUtils.between(value: -0.0, min: -0.0, max: -0.0), true);
      expect(DoubleValueUtils.between(value: -0.0, min: 0.0, max: 0.1), true);
      expect(DoubleValueUtils.between(value: 123, min: null, max: null), true);
      expect(DoubleValueUtils.between(value: 123), true);
      expect(DoubleValueUtils.between(value: double.negativeInfinity), true);
      expect(DoubleValueUtils.between(value: double.infinity), true);
      expect(DoubleValueUtils.between(value: null), true);
      expect(DoubleValueUtils.between(value: null, min: 1, max: 3), true);
      expect(DoubleValueUtils.between(value: null, min: 1000, max: 3), true);
    });

    test('Negative cases', () {
      expect(DoubleValueUtils.between(value: 1, min: 2, max: 1), false);
      expect(DoubleValueUtils.between(value: 1, min: 5, max: 8), false);
      expect(DoubleValueUtils.between(value: -0.5, min: 0), false);
      expect(DoubleValueUtils.between(value: double.nan), false);
      expect(
          DoubleValueUtils.between(value: double.nan, min: 2, max: 3), false);
      expect(DoubleValueUtils.between(value: double.infinity, min: 1, max: 3),
          false);
      expect(
          DoubleValueUtils.between(
              value: double.negativeInfinity, min: 1, max: 3),
          false);
    });
  });
}
