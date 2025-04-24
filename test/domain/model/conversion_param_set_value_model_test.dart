import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:test/test.dart';

void main() {
  const ConversionParamSetValueModel paramSetValue =
      ConversionParamSetValueModel(
    paramSet: ConversionParamSetModel(
      id: 1,
      name: "Bank Currency Rate",
      mandatory: true,
      groupId: 1,
    ),
    paramValues: [
      ConversionParamValueModel(
        param: ConversionParamModel(
          id: 1,
          name: 'Bank',
          valueType: ConvertouchValueType.text,
          paramSetId: 1,
        ),
      ),
    ],
  );

  const Map<String, dynamic> paramSetValueJson = {
    'paramSet': {
      'id': 1,
      'name': 'Bank Currency Rate',
      'mandatory': true,
      'groupId': 1,
    },
    'paramValues': [
      {
        'param': {
          'id': 1,
          'name': 'Bank',
          'valueType': 1,
          'paramSetId': 1,
          'calculable': false,
        },
        'calculated': false,
      }
    ],
  };

  test('Serialize param set value', () {
    expect(paramSetValue.toJson(), paramSetValueJson);
  });

  test('Deserialize param set value', () {
    expect(
      ConversionParamSetValueModel.fromJson(paramSetValueJson),
      paramSetValue,
    );
  });
}
