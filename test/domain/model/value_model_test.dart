import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Build value model from raw string value',
    () {
      String inputValue = "0.0098";
      ValueModel result = ValueModel.ofString(inputValue);

      expect(result.strValue, inputValue);
      expect(result.scientificValue, "0.01");
    },
  );
}
