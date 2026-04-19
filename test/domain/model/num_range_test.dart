import 'package:convertouch/domain/model/num_range.dart';
import 'package:test/test.dart';

void main() {
  group('Test num ranges include num value', () {
    test('Test closed ranges', () {
      expect(const NumRange.withBoth(0, 0).includesValue(0), true);
      expect(const NumRange.withBoth(0.0, 0.0).includesValue(0.0), true);
      expect(const NumRange.withBoth(-0.0, 0.0).includesValue(0.0), true);
      expect(const NumRange.withBoth(0.0, -0.0).includesValue(0.0), true);
      expect(const NumRange.withBoth(-0.0, -0.0).includesValue(0.0), true);
      expect(const NumRange.withBoth(-0.0, -0.0).includesValue(-0.0), true);
      expect(const NumRange.withBoth(0.0, 0.1).includesValue(-0.0), true);
      expect(const NumRange.withBoth(null, null).includesValue(123), true);
      expect(
        const NumRange.withBoth(null, null)
            .includesValue(double.negativeInfinity),
        true,
      );
      expect(const NumRange.withBoth(null, null).includesValue(double.infinity),
          true);
      expect(const NumRange.withBoth(null, null).includesValue(null), true);
      expect(const NumRange.withBoth(1, 3).includesValue(null), true);
      expect(const NumRange.withBoth(0, null).includesValue(-0.5), false);
      expect(
          const NumRange.withBoth(null, null).includesValue(double.nan), false);
      expect(const NumRange.withBoth(2, 3).includesValue(double.nan), false);
      expect(
          const NumRange.withBoth(1, 3).includesValue(double.infinity), false);
      expect(
        const NumRange.withBoth(1, 3).includesValue(double.negativeInfinity),
        false,
      );

      expect(const NumRange.withBoth(0, 2).includesValue(1), true);
      expect(const NumRange.withBoth(-2, 0).includesValue(-1), true);
      expect(const NumRange.withBoth(10, 20).includesValue(15), true);
      expect(const NumRange.withBoth(10, 20).includesValue(10), true);
      expect(const NumRange.withBoth(10, 20).includesValue(20), true);
    });

    test('Test open ranges', () {
      expect(const NumRange.withoutBoth(10, 20).includesValue(15), true);
      expect(const NumRange.withoutBoth(10, 20).includesValue(10), false);
      expect(const NumRange.withoutBoth(10, 20).includesValue(20), false);
    });

    test('Test left open ranges', () {
      expect(const NumRange.withRight(10, 20).includesValue(15), true);
      expect(const NumRange.withRight(10, 20).includesValue(10), false);
      expect(const NumRange.withRight(10, 20).includesValue(20), true);
    });

    test('Test right open ranges', () {
      expect(const NumRange.withLeft(10, 20).includesValue(15), true);
      expect(const NumRange.withLeft(10, 20).includesValue(20), false);
      expect(const NumRange.withLeft(10, 20).includesValue(10), true);
      expect(const NumRange.withLeft(10, double.infinity).includesValue(170),
          true);
    });
  });

  group('Test num ranges include another range', () {
    test('Left included, right included', () {
      expect(
        const NumRange.withBoth(-2, 2).includesRange(
            const NumRange.withoutBoth(double.negativeInfinity, 2)),
        false,
      );

      expect(
        const NumRange.withBoth(-2, 2).includesRange(
            const NumRange.withRight(double.negativeInfinity, 2)),
        false,
      );

      expect(
        const NumRange.withBoth(-2, 2)
            .includesRange(const NumRange.withLeft(-2, 2)),
        true,
      );

      expect(
        const NumRange.withBoth(-2, 2)
            .includesRange(const NumRange.withLeft(-1, 1)),
        true,
      );

      expect(
        const NumRange.withBoth(-2, 2)
            .includesRange(const NumRange.withRight(-2, 2)),
        true,
      );

      expect(
        const NumRange.withBoth(-2, 2)
            .includesRange(const NumRange.withRight(-1, 1)),
        true,
      );

      expect(
        const NumRange.withBoth(-2, 2)
            .includesRange(const NumRange.withoutBoth(-2, 2)),
        true,
      );

      expect(
        const NumRange.withBoth(-2, 2)
            .includesRange(const NumRange.withoutBoth(-1, 1)),
        true,
      );

      expect(
        const NumRange.withBoth(-2, 2)
            .includesRange(const NumRange.withLeft(-2, double.infinity)),
        false,
      );

      expect(
        const NumRange.withBoth(-2, 2)
            .includesRange(const NumRange.withoutBoth(-2, double.infinity)),
        false,
      );

      expect(
        const NumRange.withBoth(-2, 2)
            .includesRange(const NumRange.withBoth(4, 8)),
        false,
      );
    });

    test('Left included, right excluded', () {
      expect(
        const NumRange.withLeft(-2, 2).includesRange(
            const NumRange.withoutBoth(double.negativeInfinity, 2)),
        false,
      );

      expect(
        const NumRange.withLeft(-2, 2).includesRange(
            const NumRange.withRight(double.negativeInfinity, 2)),
        false,
      );

      expect(
        const NumRange.withLeft(-2, 2)
            .includesRange(const NumRange.withLeft(-2, 2)),
        true,
      );

      expect(
        const NumRange.withLeft(-2, 2)
            .includesRange(const NumRange.withLeft(-1, 1)),
        true,
      );

      expect(
        const NumRange.withLeft(-2, 2)
            .includesRange(const NumRange.withRight(-2, 2)),
        false,
      );

      expect(
        const NumRange.withLeft(-2, 2)
            .includesRange(const NumRange.withRight(-1, 1)),
        true,
      );

      expect(
        const NumRange.withLeft(-2, 2)
            .includesRange(const NumRange.withoutBoth(-2, 2)),
        true,
      );

      expect(
        const NumRange.withLeft(-2, 2)
            .includesRange(const NumRange.withoutBoth(-1, 1)),
        true,
      );

      expect(
        const NumRange.withLeft(-2, 2)
            .includesRange(const NumRange.withLeft(-2, double.infinity)),
        false,
      );

      expect(
        const NumRange.withLeft(-2, 2)
            .includesRange(const NumRange.withoutBoth(-2, double.infinity)),
        false,
      );

      expect(
        const NumRange.withLeft(-2, 2)
            .includesRange(const NumRange.withBoth(4, 8)),
        false,
      );
    });

    test('Left excluded, right included', () {
      expect(
        const NumRange.withRight(-2, 2).includesRange(
            const NumRange.withoutBoth(double.negativeInfinity, 2)),
        false,
      );

      expect(
        const NumRange.withRight(-2, 2).includesRange(
            const NumRange.withRight(double.negativeInfinity, 2)),
        false,
      );

      expect(
        const NumRange.withRight(-2, 2)
            .includesRange(const NumRange.withLeft(-2, 2)),
        false,
      );

      expect(
        const NumRange.withRight(-2, 2)
            .includesRange(const NumRange.withLeft(-1, 1)),
        true,
      );

      expect(
        const NumRange.withRight(-2, 2)
            .includesRange(const NumRange.withRight(-2, 2)),
        true,
      );

      expect(
        const NumRange.withRight(-2, 2)
            .includesRange(const NumRange.withRight(-1, 1)),
        true,
      );

      expect(
        const NumRange.withRight(-2, 2)
            .includesRange(const NumRange.withoutBoth(-2, 2)),
        true,
      );

      expect(
        const NumRange.withRight(-2, 2)
            .includesRange(const NumRange.withoutBoth(-1, 1)),
        true,
      );

      expect(
        const NumRange.withRight(-2, 2)
            .includesRange(const NumRange.withLeft(-2, double.infinity)),
        false,
      );

      expect(
        const NumRange.withRight(-2, 2)
            .includesRange(const NumRange.withoutBoth(-2, double.infinity)),
        false,
      );

      expect(
        const NumRange.withLeft(-2, 2)
            .includesRange(const NumRange.withBoth(4, 8)),
        false,
      );
    });

    test('Left excluded, right excluded', () {
      expect(
        const NumRange.withoutBoth(-2, 2).includesRange(
            const NumRange.withoutBoth(double.negativeInfinity, 2)),
        false,
      );

      expect(
        const NumRange.withoutBoth(-2, 2).includesRange(
            const NumRange.withRight(double.negativeInfinity, 2)),
        false,
      );

      expect(
        const NumRange.withoutBoth(-2, 2)
            .includesRange(const NumRange.withLeft(-2, 2)),
        false,
      );

      expect(
        const NumRange.withoutBoth(-2, 2)
            .includesRange(const NumRange.withLeft(-1, 1)),
        true,
      );

      expect(
        const NumRange.withoutBoth(-2, 2)
            .includesRange(const NumRange.withRight(-2, 2)),
        false,
      );

      expect(
        const NumRange.withoutBoth(-2, 2)
            .includesRange(const NumRange.withRight(-1, 1)),
        true,
      );

      expect(
        const NumRange.withoutBoth(-2, 2)
            .includesRange(const NumRange.withoutBoth(-2, 2)),
        true,
      );

      expect(
        const NumRange.withoutBoth(-2, 2)
            .includesRange(const NumRange.withoutBoth(-1, 1)),
        true,
      );

      expect(
        const NumRange.withoutBoth(-2, 2)
            .includesRange(const NumRange.withLeft(-2, double.infinity)),
        false,
      );

      expect(
        const NumRange.withoutBoth(-2, 2)
            .includesRange(const NumRange.withoutBoth(-2, double.infinity)),
        false,
      );

      expect(
        const NumRange.withoutBoth(-2, 2)
            .includesRange(const NumRange.withBoth(4, 8)),
        false,
      );

      expect(
        const NumRange.withoutBoth(double.negativeInfinity, 2).includesRange(
            const NumRange.withoutBoth(double.negativeInfinity, 2)),
        true,
      );

      expect(
        const NumRange.withoutBoth(double.negativeInfinity, double.infinity)
            .includesRange(
            const NumRange.withoutBoth(double.negativeInfinity, 2)),
        true,
      );

      expect(
        const NumRange.withoutBoth(double.negativeInfinity, double.infinity)
            .includesRange(const NumRange.withoutBoth(
            double.negativeInfinity, double.infinity)),
        true,
      );
    });
  });

  group('Test validation messages', () {
    test('Test closed ranges', () {
      expect(
        const NumRange.withBoth(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.withBoth(double.negativeInfinity, null)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.withBoth(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.withBoth(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.withBoth(10, null).validationMessage,
        'Value should be at least 10',
      );

      expect(
        const NumRange.withBoth(0, null).validationMessage,
        'Value should be non-negative',
      );

      expect(
        const NumRange.withBoth(null, 20).validationMessage,
        'Value should not be greater than 20',
      );

      expect(
        const NumRange.withBoth(null, 0).validationMessage,
        'Value should be non-positive',
      );

      expect(
        const NumRange.withBoth(10, 20).validationMessage,
        'Value should be in range [10 .. 20]',
      );
    });

    test('Test open ranges', () {
      expect(
        const NumRange.withoutBoth(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.withoutBoth(double.negativeInfinity, null)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.withoutBoth(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.withoutBoth(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.withoutBoth(10, null).validationMessage,
        'Value should be greater than 10',
      );

      expect(
        const NumRange.withoutBoth(0, null).validationMessage,
        'Value should be positive',
      );

      expect(
        const NumRange.withoutBoth(null, 20).validationMessage,
        'Value should be less than 20',
      );

      expect(
        const NumRange.withoutBoth(null, 0).validationMessage,
        'Value should be negative',
      );

      expect(
        const NumRange.withoutBoth(10, 20).validationMessage,
        'Value should be in range (10 .. 20)',
      );
    });

    test('Test left open ranges', () {
      expect(
        const NumRange.withRight(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.withRight(double.negativeInfinity, null)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.withRight(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.withRight(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.withRight(10, null).validationMessage,
        'Value should be greater than 10',
      );

      expect(
        const NumRange.withRight(0, null).validationMessage,
        'Value should be positive',
      );

      expect(
        const NumRange.withRight(null, 20).validationMessage,
        'Value should not be greater than 20',
      );

      expect(
        const NumRange.withRight(null, 0).validationMessage,
        'Value should be non-positive',
      );

      expect(
        const NumRange.withRight(10, 20).validationMessage,
        'Value should be in range (10 .. 20]',
      );
    });

    test('Test right open ranges', () {
      expect(
        const NumRange.withLeft(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.withLeft(double.negativeInfinity, null)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.withLeft(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.withLeft(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.withLeft(10, null).validationMessage,
        'Value should be at least 10',
      );

      expect(
        const NumRange.withLeft(0, null).validationMessage,
        'Value should be non-negative',
      );

      expect(
        const NumRange.withLeft(null, 20).validationMessage,
        'Value should be less than 20',
      );

      expect(
        const NumRange.withLeft(null, 0).validationMessage,
        'Value should be negative',
      );

      expect(
        const NumRange.withLeft(10, 20).validationMessage,
        'Value should be in range [10 .. 20)',
      );
    });
  });
}
