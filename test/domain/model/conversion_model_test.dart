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
import 'mock/mock_unit.dart';
import 'mock/mock_unit_group.dart';

void main() {
  group('By coefficients', () {
    const ConversionModel conversionByCoefficients = ConversionModel(
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
        selectedIndex: 0,
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

    const Map<String, dynamic> conversionByCoefficientsJson = {
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
        "optionalParamSetsExist": false,
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

    test('Should serialize', () {
      expect(conversionByCoefficients.toJson(), conversionByCoefficientsJson);
    });

    test('Should deserialize', () {
      expect(
        ConversionModel.fromJson(conversionByCoefficientsJson),
        conversionByCoefficients,
      );
    });
  });

  group('By mapping table', () {
    final ConversionModel conversionByMappingTable = ConversionModel(
      id: 2,
      unitGroup: clothesSizeGroup,
      srcUnitValue: ConversionUnitValueModel.tuple(japanClothSize, 'S', null),
      params: ConversionParamSetValueBulkModel(
        paramSetValues: [
          ConversionParamSetValueModel(
            paramSet: clothesSizeParamSet,
            paramValues: [
              ConversionParamValueModel.tuple(
                personParam,
                "Man",
                null,
                listValues: const OutputListValuesBatch(
                  items: [],
                  pageNum: 1,
                ),
              ),
              ConversionParamValueModel.tuple(
                garmentParam,
                "Shirt",
                null,
                listValues: const OutputListValuesBatch(
                  items: [],
                  pageNum: 1,
                ),
              ),
              ConversionParamValueModel.tuple(heightParam, 180, 1, unit: meter),
            ],
          )
        ],
        selectedIndex: 0,
      ),
      convertedUnitValues: [
        ConversionUnitValueModel.tuple(
          japanClothSize,
          'S',
          null,
          listValues: const OutputListValuesBatch(
            items: [],
            pageNum: 1,
          ),
        ),
        ConversionUnitValueModel.tuple(
          germanyClothSize,
          40,
          null,
          listValues: const OutputListValuesBatch(
            items: [],
            pageNum: 1,
          ),
        ),
      ],
    );

    const Map<String, dynamic> conversionByMappingTableJson = {
      'id': 2,
      'unitGroup': {
        'id': 6,
        'name': 'Clothes Size',
        'conversionType': 2,
        'refreshable': false,
        'valueType': 3,
        'oob': false
      },
      'sourceItem': {
        'unit': {
          'id': 7,
          'name': 'Japan',
          'code': 'JP',
          'valueType': 1,
          'listType': 5,
          'invertible': true,
          'oob': false
        },
        'value': {'raw': 'S', 'alt': 'S', 'num': null}
      },
      'params': {
        'paramSetValues': [
          {
            'paramSet': {
              'id': 1,
              'name': 'By Height',
              'mandatory': true,
              'groupId': -1
            },
            'paramValues': [
              {
                'param': {
                  'id': 1,
                  'name': 'Person',
                  'calculable': false,
                  'valueType': 1,
                  'listType': 1,
                  'paramSetId': 1
                },
                'calculated': false,
                'value': {
                  'raw': 'Man',
                  'alt': 'Man',
                  'num': null,
                },
                'listValues': {
                  'items': [],
                  'hasReachedMax': false,
                  'pageNum': 1,
                },
              },
              {
                'param': {
                  'id': 2,
                  'name': 'Garment',
                  'calculable': false,
                  'valueType': 1,
                  'listType': 2,
                  'paramSetId': 1
                },
                'calculated': false,
                'value': {
                  'raw': 'Shirt',
                  'alt': 'Shirt',
                  'num': null,
                },
                'listValues': {
                  'items': [],
                  'hasReachedMax': false,
                  'pageNum': 1,
                },
              },
              {
                'param': {
                  'id': 3,
                  'name': 'Height',
                  'unitGroupId': 1,
                  'calculable': true,
                  'valueType': 5,
                  'defaultUnit': {
                    'id': 1,
                    'name': 'Centimeter',
                    'code': 'cm',
                    'coefficient': 0.01,
                    'valueType': 5,
                    'minValue': 0.0,
                    'invertible': true,
                    'oob': false
                  },
                  'paramSetId': 1
                },
                'unit': {
                  'id': 4,
                  'name': 'Meter',
                  'code': 'm',
                  'coefficient': 1.0,
                  'valueType': 5,
                  'minValue': 0.0,
                  'invertible': true,
                  'oob': false
                },
                'calculated': false,
                'value': {'raw': '180', 'alt': '180', 'num': 180.0},
                'defaultValue': {'raw': '1', 'alt': '1', 'num': 1.0}
              }
            ]
          }
        ],
        'selectedIndex': 0,
        'paramSetsCanBeAdded': false,
        'paramSetCanBeRemoved': false,
        'optionalParamSetsExist': false,
        'mandatoryParamSetExists': false,
        'totalCount': 1
      },
      'targetItems': [
        {
          'unit': {
            'id': 7,
            'name': 'Japan',
            'code': 'JP',
            'valueType': 1,
            'listType': 5,
            'invertible': true,
            'oob': false
          },
          'value': {'raw': 'S', 'alt': 'S', 'num': null},
          'listValues': {
            'items': [],
            'hasReachedMax': false,
            'pageNum': 1,
          },
        },
        {
          'unit': {
            'id': 16,
            'name': 'Germany',
            'code': 'DE',
            'valueType': 3,
            'listType': 11,
            'invertible': true,
            'oob': false
          },
          'value': {'raw': '40', 'alt': '40', 'num': 40.0},
          'listValues': {
            'items': [],
            'hasReachedMax': false,
            'pageNum': 1,
          },
        }
      ]
    };

    test('Should serialize', () {
      expect(conversionByMappingTable.toJson(), conversionByMappingTableJson);
    });

    test('Should deserialize', () {
      expect(
        ConversionModel.fromJson(conversionByMappingTableJson),
        conversionByMappingTable,
      );
    });
  });
}
