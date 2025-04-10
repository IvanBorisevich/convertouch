import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:test/test.dart';

void main() {
  const ConversionParamSetModel paramSet = ConversionParamSetModel(
    id: 1,
    name: "Bank Currency Rate",
    mandatory: true,
    groupId: 1,
  );

  const Map<String, dynamic> paramSetJson = {
    'id': 1,
    'name': 'Bank Currency Rate',
    'mandatory': true,
    'groupId': 1,
  };

  test('Serialize param set', () {
    expect(paramSet.toJson(), paramSetJson);
  });

  test('Deserialize param set', () {
    expect(ConversionParamSetModel.fromJson(paramSetJson), paramSet);
  });
}
