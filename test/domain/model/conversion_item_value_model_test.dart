import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

import 'mock/mock_param.dart';
import 'mock/mock_unit.dart';

void main() {
  group('For conversion param value', () {
    const ConversionParamValueModel heightParamVal = ConversionParamValueModel(
      param: heightParam,
      unit: meter,
      value: ValueModel.one,
      defaultValue: ValueModel.one,
    );

    const Map<String, dynamic> paramValueJson = {
      'param': {
        'id': 3,
        'name': 'Height',
        'unitGroupId': 1,
        'valueType': 5,
        'paramSetId': 1,
        'calculable': false,
        'defaultUnit': {
          'id': 1,
          'name': 'Centimeter',
          'code': 'cm',
          'coefficient': 0.01,
          'valueType': 5,
          'minValue': 0,
          'invertible': true,
          'oob': false
        },
      },
      'unit': {
        "id": 4,
        "name": 'Meter',
        "code": 'm',
        "coefficient": 1.0,
        "valueType": 5,
        "minValue": 0,
        "invertible": true,
        "oob": false,
      },
      'value': {
        'raw': '1',
        'num': 1,
        'alt': '1',
      },
      'defaultValue': {
        'raw': '1',
        'num': 1,
        'alt': '1',
      },
      'calculated': false,
    };

    test('Serialize param value', () {
      expect(heightParamVal.toJson(), paramValueJson);
    });

    test('Deserialize param value', () {
      expect(
        ConversionParamValueModel.fromJson(paramValueJson),
        heightParamVal,
      );
    });
  });

  group('For conversion unit value', () {
    const ConversionUnitValueModel unitValue = ConversionUnitValueModel(
      unit: meter,
      value: ValueModel.one,
      defaultValue: ValueModel.one,
    );

    const Map<String, dynamic> unitValueJson = {
      'unit': {
        "id": 4,
        "name": 'Meter',
        "code": 'm',
        "coefficient": 1.0,
        "valueType": 5,
        "minValue": 0,
        "invertible": true,
        "oob": false,
      },
      'value': {
        'raw': '1',
        'num': 1,
        'alt': '1',
      },
      'defaultValue': {
        'raw': '1',
        'num': 1,
        'alt': '1',
      },
    };

    test('Serialize unit value', () {
      expect(unitValue.toJson(), unitValueJson);
    });

    test('Deserialize unit value', () {
      expect(ConversionUnitValueModel.fromJson(unitValueJson), unitValue);
    });
  });
}
