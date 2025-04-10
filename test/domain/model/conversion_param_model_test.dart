import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:test/test.dart';

void main() {
  const ConversionParamModel param = ConversionParamModel(
    id: 1,
    name: "Height",
    unitGroupId: 1,
    valueType: ConvertouchValueType.decimalPositive,
    paramSetId: 1,
  );

  const Map<String, dynamic> paramJson = {
    'id': 1,
    'name': 'Height',
    'unitGroupId': 1,
    'valueType': 5,
    'paramSetId': 1,
    'calculable': false,
  };

  test('Serialize param', () {
    expect(param.toJson(), paramJson);
  });

  test('Deserialize param', () {
    expect(ConversionParamModel.fromJson(paramJson), param);
  });
}
