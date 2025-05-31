import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:test/test.dart';

import 'mock/mock_param.dart';

void main() {
  const Map<String, dynamic> paramSetJson = {
    'id': 5,
    'name': 'Bank Currency Rate',
    'mandatory': true,
    'groupId': -1,
  };

  test('Serialize param set', () {
    expect(bankCurrencyRateParamSet.toJson(), paramSetJson);
  });

  test('Deserialize param set', () {
    expect(ConversionParamSetModel.fromJson(paramSetJson),
        bankCurrencyRateParamSet);
  });
}
