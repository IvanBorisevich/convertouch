import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Should generate int list', () {
    expect(ObjectUtils.generateNumList(34, 48, step: 2),
        ['34', '36', '38', '40', '42', '44', '46', '48']);
  });

  test('Should generate fraction list', () {
    expect(ObjectUtils.generateNumList(34, 43, step: 1.5),
        ['34', '35.5', '37', '38.5', '40', '41.5', '43']);
  });

  test('Should generate int list with divisor', () {
    expect(ObjectUtils.generateNumList(1, 5, step: 1, divisor: 2),
        ['0.5', '1', '1.5', '2', '2.5']);
  });

  test('Should generate fraction list with divisor', () {
    expect(ObjectUtils.generateNumList(3, 12, step: 3, divisor: 2),
        ['1.5', '3', '4.5', '6']);
  });

  test('Should transform int list', () {
    expect(ObjectUtils.fromNumList([2, 4, 6, 8]), ['2', '4', '6', '8']);
  });

  test('Should transform fraction list', () {
    expect(
        ObjectUtils.fromNumList([1.5, 3.55, 4, 7]), ['1.5', '3.55', '4', '7']);
  });

  test('Should transform fraction list with fraction digits set', () {
    expect(ObjectUtils.fromNumList([1.5, 3.55, 4, 7], fractionDigits: 1),
        ['1.5', '3.5', '4', '7']);
  });

  test('Should transform int list with divisor', () {
    expect(ObjectUtils.fromNumList([2, 4, 6, 8], divisor: 2),
        ['1', '2', '3', '4']);
  });

  test('Should transform fraction list with divisor', () {
    expect(ObjectUtils.fromNumList([1, 3, 4, 7], divisor: 2, fractionDigits: 1),
        ['0.5', '1.5', '2', '3.5']);
  });

  test('Should generate alpha lists', () {
    expect(ObjectUtils.generateAlphaList('A', 'F'),
        ['A', 'B', 'C', 'D', 'E', 'F']);

    expect(ObjectUtils.generateAlphaList('B', 'F'), ['B', 'C', 'D', 'E', 'F']);

    expect(ObjectUtils.generateAlphaList('F', 'A'), []);
  });
}
