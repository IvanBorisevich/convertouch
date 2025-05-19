import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:test/test.dart';

import 'mock/mock_param.dart';

const _paramSetValue = ConversionParamSetValueModel(
  paramSet: barbellWeightParamSet,
  paramValues: [
    ConversionParamValueModel(
      param: barWeightParam,
    ),
    ConversionParamValueModel(
      param: oneSideWeightParam,
    ),
  ],
);

const _paramSetValueWithMultipleCalculableParams = ConversionParamSetValueModel(
  paramSet: barbellWeightParamSet,
  paramValues: [
    ConversionParamValueModel(
      param: barWeightParam,
    ),
    ConversionParamValueModel(
      param: oneSideWeightParam,
      calculated: true,
    ),
    ConversionParamValueModel(
      param: someCalculableParam,
    ),
  ],
);

const Map<String, dynamic> paramSetValueJson = {
  'paramSet': {
    'id': 4,
    'name': 'Barbell Weight',
    'mandatory': false,
    'groupId': -1,
  },
  'paramValues': [
    {
      'param': {
        'id': 5,
        'name': 'Bar Weight',
        'unitGroupId': 3,
        'calculable': false,
        'valueType': 5,
        'listType': 15,
        'defaultUnit': {
          'id': 13,
          'name': 'Kilogram',
          'code': 'kg',
          'coefficient': 1.0,
          'valueType': 5,
          'minValue': 0,
          'invertible': true,
          'oob': false
        },
        'paramSetId': 4
      },
      'calculated': false
    },
    {
      'param': {
        'id': 6,
        'name': 'One Side Weight',
        'unitGroupId': 3,
        'calculable': true,
        'valueType': 5,
        'defaultUnit': {
          'id': 13,
          'name': 'Kilogram',
          'code': 'kg',
          'coefficient': 1.0,
          'valueType': 5,
          'minValue': 0,
          'invertible': true,
          'oob': false
        },
        'paramSetId': 4
      },
      'calculated': false
    }
  ]
};

void main() {
  test('Serialize param set value', () {
    expect(_paramSetValue.toJson(), paramSetValueJson);
  });

  test('Deserialize param set value', () {
    expect(
      ConversionParamSetValueModel.fromJson(paramSetValueJson),
      _paramSetValue,
    );
  });

  test('Check whether it has multiple calculable params', () {
    expect(_paramSetValue.hasMultipleCalculableParams, false);

    expect(
      _paramSetValueWithMultipleCalculableParams.hasMultipleCalculableParams,
      true,
    );
  });

  test('Switch on the calculable param first time', () {
    expect(
      _paramSetValue.copyWithNewCalculatedParam(
        newCalculatedParamId: oneSideWeightParam.id,
      ),
      const ConversionParamSetValueModel(
        paramSet: barbellWeightParamSet,
        paramValues: [
          ConversionParamValueModel(
            param: barWeightParam,
          ),
          ConversionParamValueModel(
            param: oneSideWeightParam,
            calculated: true,
          ),
        ],
      ),
    );
  });

  test('Switch on another calculable param', () {
    expect(
      _paramSetValueWithMultipleCalculableParams.copyWithNewCalculatedParam(
        newCalculatedParamId: someCalculableParam.id,
      ),
      const ConversionParamSetValueModel(
        paramSet: barbellWeightParamSet,
        paramValues: [
          ConversionParamValueModel(
            param: barWeightParam,
          ),
          ConversionParamValueModel(
            param: oneSideWeightParam,
          ),
          ConversionParamValueModel(
            param: someCalculableParam,
            calculated: true,
          ),
        ],
      ),
    );
  });

  test('Switch off the calculable param', () {
    expect(
      _paramSetValueWithMultipleCalculableParams.copyWithNewCalculatedParam(
        newCalculatedParamId: oneSideWeightParam.id,
      ),
      const ConversionParamSetValueModel(
        paramSet: barbellWeightParamSet,
        paramValues: [
          ConversionParamValueModel(
            param: barWeightParam,
          ),
          ConversionParamValueModel(
            param: oneSideWeightParam,
          ),
          ConversionParamValueModel(
            param: someCalculableParam,
          ),
        ],
      ),
    );
  });
}
