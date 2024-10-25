import 'package:convertouch/domain/utils/double_value_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Format to scientific notation', () {
    test(
      'Values with exponent [-4..7] should not be formatted to scientific',
      () {
        expect(DoubleValueUtils.toScientific(-0010000000), "-10000000");
        expect(DoubleValueUtils.toScientific(-10000000), "-10000000");
        expect(DoubleValueUtils.toScientific(-1000000), "-1000000");
        expect(DoubleValueUtils.toScientific(-1.236236478785), "-1.2362364788");
        expect(DoubleValueUtils.toScientific(-1), "-1");
        expect(DoubleValueUtils.toScientific(-0.9999), "-0.9999");
        expect(DoubleValueUtils.toScientific(-000.9999), "-0.9999");
        expect(DoubleValueUtils.toScientific(-1E-4), "-0.0001");
        expect(DoubleValueUtils.toScientific(0), "0");
        expect(DoubleValueUtils.toScientific(-0), "0");
        expect(DoubleValueUtils.toScientific(0.001), "0.001");
        expect(DoubleValueUtils.toScientific(0.0098), "0.0098");
        expect(DoubleValueUtils.toScientific(0.00980665), "0.00980665");
        expect(DoubleValueUtils.toScientific(0.9999), "0.9999");
        expect(DoubleValueUtils.toScientific(000.9999), "0.9999");
        expect(DoubleValueUtils.toScientific(1), "1");
        expect(DoubleValueUtils.toScientific(1.236236478785), "1.2362364788");
        expect(DoubleValueUtils.toScientific(1000000), "1000000");
        expect(DoubleValueUtils.toScientific(10000000), "10000000");
        expect(DoubleValueUtils.toScientific(0010000000), "10000000");
      },
    );

    test('Values with exponent < -4 should be formatted', () {
      expect(DoubleValueUtils.toScientific(-1E-7), "-10¯⁷");
      expect(DoubleValueUtils.toScientific(-0.0000001), "-10¯⁷");
      expect(DoubleValueUtils.toScientific(-0.000013), "-1.3 · 10¯⁵");
      expect(DoubleValueUtils.toScientific(-0.0000323), "-3.23 · 10¯⁵");
      expect(DoubleValueUtils.toScientific(0.0000017), "1.7 · 10¯⁶");
      expect(DoubleValueUtils.toScientific(0.00000178), "1.78 · 10¯⁶");
      expect(DoubleValueUtils.toScientific(0.000001781), "1.78 · 10¯⁶");
      expect(DoubleValueUtils.toScientific(0.000001785), "1.79 · 10¯⁶");
      expect(DoubleValueUtils.toScientific(-0.0000017), "-1.7 · 10¯⁶");
      expect(DoubleValueUtils.toScientific(-0.00000178), "-1.78 · 10¯⁶");
      expect(DoubleValueUtils.toScientific(-0.000001781), "-1.78 · 10¯⁶");
      expect(DoubleValueUtils.toScientific(-0.000001785), "-1.79 · 10¯⁶");
      expect(DoubleValueUtils.toScientific(0.00000003), "3 · 10¯⁸");
      expect(DoubleValueUtils.toScientific(0.000000003), "3 · 10¯⁹");
      expect(DoubleValueUtils.toScientific(0.000000001), "10¯⁹");
      expect(DoubleValueUtils.toScientific(4E-23), "4 · 10¯²³");
    });

    test('Values with exponent > 7 should be formatted', () {
      expect(DoubleValueUtils.toScientific(1E21), "10²¹");
      expect(DoubleValueUtils.toScientific(123E15), "1.23 · 10¹⁷");
      expect(DoubleValueUtils.toScientific(123E21), "1.23 · 10²³");
      expect(
        DoubleValueUtils.toScientific(123.44E21,
            fractionDigitsInSignificand: 3),
        "1.234 · 10²³",
      );
    });

    test('Value null should be formatted to the empty string', () {
      expect(DoubleValueUtils.toScientific(null), "");
    });
  });

  group("Format to a plain string", () {
    test('Fraction digits should be as maximum 10 by default', () {
      expect(DoubleValueUtils.toPlain(56746345631111.000), "56746345631111");
      expect(DoubleValueUtils.toPlain(1.0), "1");
    });

    test('Value null should be formatted to the empty string', () {
      expect(DoubleValueUtils.toPlain(null), "");
    });

    test('Fraction digits should be trimmed by explicit parameter', () {
      expect(DoubleValueUtils.toPlain(0.56746, fractionDigits: 5), "0.56746");
      expect(
        DoubleValueUtils.toPlain(5674634563.0012, fractionDigits: 3),
        "5674634563.001",
      );
      expect(DoubleValueUtils.toPlain(0.001, fractionDigits: 8), "0.001");
      expect(
          DoubleValueUtils.toPlain(
            0.001000000000000002,
            fractionDigits: 9,
          ),
          "0.001");
    });

    test('Fraction trailing zeros should always be trimmed', () {
      expect(DoubleValueUtils.toPlain(35.0000000, fractionDigits: 5), "35");
      expect(DoubleValueUtils.toPlain(0035.0000000, fractionDigits: 5), "35");
      expect(DoubleValueUtils.toPlain(35.0000000), "35");
      expect(DoubleValueUtils.toPlain(1.056000), "1.056");
      expect(DoubleValueUtils.toPlain(001.056000), "1.056");
      expect(DoubleValueUtils.toPlain(1.0), "1");
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
