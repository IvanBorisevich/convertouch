import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/item_model.dart';
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
        'calculable': true,
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

  group('For conversion param value with list values', () {
    final barWeightParamVal = ConversionParamValueModel.tuple(
      barWeightParam,
      10,
      null,
      unit: kilogram,
      listValues: const OutputListValuesBatch(
        items: [
          ListValueModel.value("10"),
          ListValueModel.value("20"),
        ],
        pageNum: 1,
        hasReachedMax: true,
        fetchedRemotely: true,
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
        'items': [
          {'value': '10'},
          {'value': '20'}
        ],
        'pageNum': 1,
        'fetchedRemotely': true,
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
