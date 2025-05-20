import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_bulk_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

import 'mock/mock_param.dart';

void main() {
  const ConversionModel conversion = ConversionModel(
    id: 1,
    unitGroup: UnitGroupModel(
      id: 10,
      name: 'Money',
      conversionType: ConversionType.dynamic,
      refreshable: true,
      valueType: ConvertouchValueType.decimalPositive,
    ),
    srcUnitValue: ConversionUnitValueModel(
      unit: UnitModel(
        id: 7,
        name: 'Euro',
        code: 'EUR',
        valueType: ConvertouchValueType.decimalPositive,
      ),
      value: ValueModel.one,
      defaultValue: ValueModel.one,
    ),
    params: ConversionParamSetValueBulkModel(
      paramSetValues: [
        ConversionParamSetValueModel(
          paramSet: bankCurrencyRateParamSet,
          paramValues: [
            ConversionParamValueModel(
              param: bankParam,
            ),
          ],
        ),
      ],
      totalCount: 1,
      mandatoryParamSetExists: true,
    ),
    convertedUnitValues: [
      ConversionUnitValueModel(
        unit: UnitModel(
          id: 8,
          name: 'United States Dollar',
          code: 'USD',
          valueType: ConvertouchValueType.decimalPositive,
        ),
        value: ValueModel.one,
        defaultValue: ValueModel.one,
      ),
      ConversionUnitValueModel(
        unit: UnitModel(
          id: 9,
          name: 'Australian Dollar',
          code: 'AUD',
          valueType: ConvertouchValueType.decimalPositive,
        ),
        value: ValueModel.one,
        defaultValue: ValueModel.one,
      ),
    ],
  );

  const Map<String, dynamic> conversionJson = {
    'id': 1,
    'unitGroup': {
      'id': 10,
      'name': 'Money',
      'conversionType': 1,
      'refreshable': true,
      'valueType': 5,
      'oob': false,
    },
    'params': {
      'paramSetValues': [
        {
          'paramSet': {
            'id': 5,
            'name': 'Bank Currency Rate',
            'mandatory': true,
            'groupId': -1,
          },
          'paramValues': [
            {
              'param': {
                'id': 8,
                'name': 'Bank',
                'valueType': 1,
                'paramSetId': 5,
                'calculable': false,
              },
              'calculated': false,
            }
          ],
        },
      ],
      'selectedIndex': 0,
      "paramSetsCanBeAdded": false,
      "paramSetCanBeRemoved": false,
      "paramSetsCanBeRemovedInBulk": false,
      "mandatoryParamSetExists": true,
      'totalCount': 1,
    },
    'sourceItem': {
      'unit': {
        'id': 7,
        'name': 'Euro',
        'code': 'EUR',
        'valueType': 5,
        'invertible': true,
        'oob': false,
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
    },
    'targetItems': [
      {
        'unit': {
          'id': 8,
          'name': 'United States Dollar',
          'code': 'USD',
          'valueType': 5,
          'invertible': true,
          'oob': false,
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
      },
      {
        'unit': {
          'id': 9,
          'name': 'Australian Dollar',
          'code': 'AUD',
          'valueType': 5,
          'invertible': true,
          'oob': false,
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
      },
    ]
  };

  test('Serialize conversion', () {
    expect(conversion.toJson(), conversionJson);
  });

  test('Deserialize conversion', () {
    expect(ConversionModel.fromJson(conversionJson), conversion);
  });
}
