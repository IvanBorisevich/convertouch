import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Test list generation', () {
    expect(ObjectUtils.generateList(34, 48, 2),
        ['34', '36', '38', '40', '42', '44', '46', '48']);
  });
}
