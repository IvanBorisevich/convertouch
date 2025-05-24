import 'package:convertouch/domain/model/num_range.dart';
import 'package:test/test.dart';

void main() {
  test('Test num range', () {
    expect(const NumRange(10, 20).contains(10), true);
    expect(const NumRange(10, 20).contains(20), true);
    expect(const NumRange(10, 20).contains(15), true);
    expect(const NumRange(10, double.infinity).contains(170), true);
    expect(const NumRange(10, 11).contains(null), false);

    expect(const NumRange.open(10, 20).contains(15), true);
    expect(const NumRange.open(10, 20).contains(10), false);
    expect(const NumRange.open(10, 20).contains(20), false);

    expect(const NumRange.closed(10, 20).contains(15), true);
    expect(const NumRange.closed(10, 20).contains(10), true);
    expect(const NumRange.closed(10, 20).contains(20), true);

    expect(const NumRange.leftOpen(10, 20).contains(15), true);
    expect(const NumRange.leftOpen(10, 20).contains(10), false);
    expect(const NumRange.leftOpen(10, 20).contains(20), true);

    expect(const NumRange.rightOpen(10, 20).contains(15), true);
    expect(const NumRange.rightOpen(10, 20).contains(20), false);
    expect(const NumRange.rightOpen(10, 20).contains(10), true);
    expect(const NumRange.rightOpen(10, double.infinity).contains(170), true);
  });
}
