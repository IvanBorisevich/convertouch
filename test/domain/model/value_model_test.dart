import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

void main() {
  void testForInput({required String raw, required String expectedScientificValue,}) {
    ValueModel result = ValueModel.ofString(raw);

    expect(result.str, raw);
    expect(result.scientific, expectedScientificValue);
  }

  test('Build value model from raw string value', () {
    testForInput(raw: "0.0098", expectedScientificValue: "0.0098");
  });
}
