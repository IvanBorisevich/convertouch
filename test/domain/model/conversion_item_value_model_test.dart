import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

import 'mock/mock_param.dart';
import 'mock/mock_unit.dart';

void main() {
  group(
      'For conversion param value with list values '
      '(local list values should not be serialized)', () {
    final barWeightParamVal = ConversionParamValueModel.tuple(
      barWeightParam,
      10,
      null,
      unit: kilogram,
      listValues: const OutputListValuesBatch(
        items: [],
        pageNum: 1,
        hasReachedMax: true,
      ),
    );

    const Map<String, dynamic> barWeightParamValueJson = {
      'param': {
        'id': 5,
        'name': 'Bar Weight',
        'unitGroupId': 3,
        'valueType': 5,
        'listType': 17,
        'paramSetId': 4,
        'calculable': false,
        'defaultUnit': {
          'id': 13,
          'name': 'Kilogram',
          'code': 'kg',
          'coefficient': 1,
          'valueType': 5,
          'minValue': 0,
          'unitGroupId': 9,
          'invertible': true,
          'oob': false,
        },
      },
      'unit': {
        'id': 13,
        'name': 'Kilogram',
        'code': 'kg',
        'coefficient': 1,
        'valueType': 5,
        'minValue': 0,
        'unitGroupId': 9,
        'invertible': true,
        'oob': false,
      },
      'value': {
        'raw': '10',
        'num': 10,
        'alt': '10',
      },
      'calculated': false,
      'listValues': {
        'items': [],
        'pageNum': 1,
        'hasReachedMax': true,
      },
    };

    test('Serialize param value', () {
      expect(barWeightParamVal.toJson(), barWeightParamValueJson);
    });

    test('Deserialize param value', () {
      expect(
        ConversionParamValueModel.fromJson(barWeightParamValueJson),
        barWeightParamVal,
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
        'unitGroupId': 5,
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
