import 'package:convertouch/domain/model/num_range.dart';
import 'package:test/test.dart';

void main() {
  group('Test num ranges', () {
    test('Test closed ranges', () {
      expect(const NumRange.leftRightIncluded(0, 0).contains(0), true);
      expect(const NumRange.leftRightIncluded(0.0, 0.0).contains(0.0), true);
      expect(const NumRange.leftRightIncluded(-0.0, 0.0).contains(0.0), true);
      expect(const NumRange.leftRightIncluded(0.0, -0.0).contains(0.0), true);
      expect(const NumRange.leftRightIncluded(-0.0, -0.0).contains(0.0), true);
      expect(const NumRange.leftRightIncluded(-0.0, -0.0).contains(-0.0), true);
      expect(const NumRange.leftRightIncluded(0.0, 0.1).contains(-0.0), true);
      expect(const NumRange.leftRightIncluded(null, null).contains(123), true);
      expect(
        const NumRange.leftRightIncluded(null, null).contains(double.negativeInfinity),
        true,
      );
      expect(const NumRange.leftRightIncluded(null, null).contains(double.infinity), true);
      expect(const NumRange.leftRightIncluded(null, null).contains(null), true);
      expect(const NumRange.leftRightIncluded(1, 3).contains(null), true);
      expect(const NumRange.leftRightIncluded(0, null).contains(-0.5), false);
      expect(const NumRange.leftRightIncluded(null, null).contains(double.nan), false);
      expect(const NumRange.leftRightIncluded(2, 3).contains(double.nan), false);
      expect(const NumRange.leftRightIncluded(1, 3).contains(double.infinity), false);
      expect(
        const NumRange.leftRightIncluded(1, 3).contains(double.negativeInfinity),
        false,
      );

      expect(const NumRange.leftRightIncluded(0, 2).contains(1), true);
      expect(const NumRange.leftRightIncluded(-2, 0).contains(-1), true);
      expect(const NumRange.leftRightIncluded(10, 20).contains(15), true);
      expect(const NumRange.leftRightIncluded(10, 20).contains(10), true);
      expect(const NumRange.leftRightIncluded(10, 20).contains(20), true);
    });

    test('Test open ranges', () {
      expect(const NumRange.leftRightExcluded(10, 20).contains(15), true);
      expect(const NumRange.leftRightExcluded(10, 20).contains(10), false);
      expect(const NumRange.leftRightExcluded(10, 20).contains(20), false);
    });

    test('Test left open ranges', () {
      expect(const NumRange.rightIncluded(10, 20).contains(15), true);
      expect(const NumRange.rightIncluded(10, 20).contains(10), false);
      expect(const NumRange.rightIncluded(10, 20).contains(20), true);
    });

    test('Test right open ranges', () {
      expect(const NumRange.leftIncluded(10, 20).contains(15), true);
      expect(const NumRange.leftIncluded(10, 20).contains(20), false);
      expect(const NumRange.leftIncluded(10, 20).contains(10), true);
      expect(const NumRange.leftIncluded(10, double.infinity).contains(170), true);
    });
  });

  group('Test validation messages', () {
    test('Test closed ranges', () {
      expect(
        const NumRange.leftRightIncluded(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.leftRightIncluded(double.negativeInfinity, null).validationMessage,
        null,
      );

      expect(
        const NumRange.leftRightIncluded(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.leftRightIncluded(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.leftRightIncluded(10, null).validationMessage,
        'Value should be at least 10',
      );

      expect(
        const NumRange.leftRightIncluded(0, null).validationMessage,
        'Value should be non-negative',
      );

      expect(
        const NumRange.leftRightIncluded(null, 20).validationMessage,
        'Value should not be greater than 20',
      );

      expect(
        const NumRange.leftRightIncluded(null, 0).validationMessage,
        'Value should be non-positive',
      );

      expect(
        const NumRange.leftRightIncluded(10, 20).validationMessage,
        'Value should be in range [10 .. 20]',
      );
    });

    test('Test open ranges', () {
      expect(
        const NumRange.leftRightExcluded(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.leftRightExcluded(double.negativeInfinity, null).validationMessage,
        null,
      );

      expect(
        const NumRange.leftRightExcluded(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.leftRightExcluded(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.leftRightExcluded(10, null).validationMessage,
        'Value should be greater than 10',
      );

      expect(
        const NumRange.leftRightExcluded(0, null).validationMessage,
        'Value should be positive',
      );

      expect(
        const NumRange.leftRightExcluded(null, 20).validationMessage,
        'Value should be less than 20',
      );

      expect(
        const NumRange.leftRightExcluded(null, 0).validationMessage,
        'Value should be negative',
      );

      expect(
        const NumRange.leftRightExcluded(10, 20).validationMessage,
        'Value should be in range (10 .. 20)',
      );
    });

    test('Test left open ranges', () {
      expect(
        const NumRange.rightIncluded(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.rightIncluded(double.negativeInfinity, null)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.rightIncluded(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.rightIncluded(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.rightIncluded(10, null).validationMessage,
        'Value should be greater than 10',
      );

      expect(
        const NumRange.rightIncluded(0, null).validationMessage,
        'Value should be positive',
      );

      expect(
        const NumRange.rightIncluded(null, 20).validationMessage,
        'Value should not be greater than 20',
      );

      expect(
        const NumRange.rightIncluded(null, 0).validationMessage,
        'Value should be non-positive',
      );

      expect(
        const NumRange.rightIncluded(10, 20).validationMessage,
        'Value should be in range (10 .. 20]',
      );
    });

    test('Test right open ranges', () {
      expect(
        const NumRange.leftIncluded(null, null).validationMessage,
        null,
      );

      expect(
        const NumRange.leftIncluded(double.negativeInfinity, null)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.leftIncluded(null, double.infinity).validationMessage,
        null,
      );

      expect(
        const NumRange.leftIncluded(double.negativeInfinity, double.infinity)
            .validationMessage,
        null,
      );

      expect(
        const NumRange.leftIncluded(10, null).validationMessage,
        'Value should be at least 10',
      );

      expect(
        const NumRange.leftIncluded(0, null).validationMessage,
        'Value should be non-negative',
      );

      expect(
        const NumRange.leftIncluded(null, 20).validationMessage,
        'Value should be less than 20',
      );

      expect(
        const NumRange.leftIncluded(null, 0).validationMessage,
        'Value should be negative',
      );

      expect(
        const NumRange.leftIncluded(10, 20).validationMessage,
        'Value should be in range [10 .. 20)',
      );
    });
  });
}
