import 'package:convertouch/domain/utils/mapping_table.dart';
import 'package:test/test.dart';

void main() {
  test('Test criteria', () {
    expect(const NumRangeCriterion(10, 20).contains(10), true);
    expect(const NumRangeCriterion(10, 20).contains(20), true);
    expect(const NumRangeCriterion(10, 20).contains(15), true);
    expect(const NumRangeCriterion(10, 20).contains(10, includeLeft: false),
        false);
    expect(const NumRangeCriterion(10, 20).contains(20, includeRight: false),
        false);
    expect(
        const NumRangeCriterion(10, 20).contains(15, includeLeft: false), true);
    expect(const NumRangeCriterion(10, 20).contains(15, includeRight: false),
        true);
    expect(const NumRangeCriterion(10, double.infinity).contains(170), true);
    expect(
        const NumRangeCriterion(10, double.infinity)
            .contains(170, includeRight: false),
        true);
  });
}
