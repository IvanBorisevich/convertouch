import 'package:convertouch/domain/model/num_range.dart';
import 'package:test/test.dart';

void main() {
  group('Test num ranges', () {
    test('Test closed ranges', () {
      expect(const NumRange.closed(0, 0).contains(0), true);
      expect(const NumRange.closed(0.0, 0.0).contains(0.0), true);
      expect(const NumRange.closed(-0.0, 0.0).contains(0.0), true);
      expect(const NumRange.closed(0.0, -0.0).contains(0.0), true);
      expect(const NumRange.closed(-0.0, -0.0).contains(0.0), true);
      expect(const NumRange.closed(-0.0, -0.0).contains(-0.0), true);
      expect(const NumRange.closed(0.0, 0.1).contains(-0.0), true);
      expect(const NumRange.closed(null, null).contains(123), true);
      expect(
        const NumRange.closed(null, null).contains(double.negativeInfinity),
        true,
      );
      expect(const NumRange.closed(null, null).contains(double.infinity), true);
      expect(const NumRange.closed(null, null).contains(null), true);
      expect(const NumRange.closed(1, 3).contains(null), true);
      expect(const NumRange.closed(0, null).contains(-0.5), false);
      expect(const NumRange.closed(null, null).contains(double.nan), false);
      expect(const NumRange.closed(2, 3).contains(double.nan), false);
      expect(const NumRange.closed(1, 3).contains(double.infinity), false);
      expect(
        const NumRange.closed(1, 3).contains(double.negativeInfinity),
        false,
      );

      expect(const NumRange.closed(0, 2).contains(1), true);
      expect(const NumRange.closed(-2, 0).contains(-1), true);
      expect(const NumRange.closed(10, 20).contains(15), true);
      expect(const NumRange.closed(10, 20).contains(10), true);
      expect(const NumRange.closed(10, 20).contains(20), true);
    });

    test('Test open ranges', () {
      expect(const NumRange.open(10, 20).contains(15), true);
      expect(const NumRange.open(10, 20).contains(10), false);
      expect(const NumRange.open(10, 20).contains(20), false);
    });

    test('Test left open ranges', () {
      expect(const NumRange.leftOpen(10, 20).contains(15), true);
      expect(const NumRange.leftOpen(10, 20).contains(10), false);
      expect(const NumRange.leftOpen(10, 20).contains(20), true);
    });

    test('Test right open ranges', () {
      expect(const NumRange.rightOpen(10, 20).contains(15), true);
      expect(const NumRange.rightOpen(10, 20).contains(20), false);
      expect(const NumRange.rightOpen(10, 20).contains(10), true);
      expect(const NumRange.rightOpen(10, double.infinity).contains(170), true);
    });
  });

  group('Test validation messages', () {
    test('Test closed ranges', () {
      expect(
        const NumRange.closed(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.closed(double.negativeInfinity, null).validationMessage,
        null,
      );

      expect(
        const NumRange.closed(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.closed(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.closed(10, null).validationMessage,
        'Value should be at least 10',
      );

      expect(
        const NumRange.closed(0, null).validationMessage,
        'Value should be non-negative',
      );

      expect(
        const NumRange.closed(null, 20).validationMessage,
        'Value should not be greater than 20',
      );

      expect(
        const NumRange.closed(null, 0).validationMessage,
        'Value should be non-positive',
      );

      expect(
        const NumRange.closed(10, 20).validationMessage,
        'Value should be in range [10 .. 20]',
      );
    });

    test('Test open ranges', () {
      expect(
        const NumRange.open(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.open(double.negativeInfinity, null).validationMessage,
        null,
      );

      expect(
        const NumRange.open(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.open(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.open(10, null).validationMessage,
        'Value should be greater than 10',
      );

      expect(
        const NumRange.open(0, null).validationMessage,
        'Value should be positive',
      );

      expect(
        const NumRange.open(null, 20).validationMessage,
        'Value should be less than 20',
      );

      expect(
        const NumRange.open(null, 0).validationMessage,
        'Value should be negative',
      );

      expect(
        const NumRange.open(10, 20).validationMessage,
        'Value should be in range (10 .. 20)',
      );
    });

    test('Test left open ranges', () {
      expect(
        const NumRange.leftOpen(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.leftOpen(double.negativeInfinity, null)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.leftOpen(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.leftOpen(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.leftOpen(10, null).validationMessage,
        'Value should be greater than 10',
      );

      expect(
        const NumRange.leftOpen(0, null).validationMessage,
        'Value should be positive',
      );

      expect(
        const NumRange.leftOpen(null, 20).validationMessage,
        'Value should not be greater than 20',
      );

      expect(
        const NumRange.leftOpen(null, 0).validationMessage,
        'Value should be non-positive',
      );

      expect(
        const NumRange.leftOpen(10, 20).validationMessage,
        'Value should be in range (10 .. 20]',
      );
    });

    test('Test right open ranges', () {
      expect(
        const NumRange.rightOpen(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.rightOpen(double.negativeInfinity, null)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.rightOpen(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.rightOpen(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.rightOpen(10, null).validationMessage,
        'Value should be at least 10',
      );

      expect(
        const NumRange.rightOpen(0, null).validationMessage,
        'Value should be non-negative',
      );

      expect(
        const NumRange.rightOpen(null, 20).validationMessage,
        'Value should be less than 20',
      );

      expect(
        const NumRange.rightOpen(null, 0).validationMessage,
        'Value should be negative',
      );

      expect(
        const NumRange.rightOpen(10, 20).validationMessage,
        'Value should be in range [10 .. 20)',
      );
    });
  });
}
