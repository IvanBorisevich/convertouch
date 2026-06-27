import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/item_value_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:test/test.dart';

import 'mock/mock_param.dart';
import 'mock/mock_unit_group.dart';

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

const Map<String, dynamic> _paramSetValueJson = {
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
        'listType': 17,
        'defaultUnit': {
          'id': 13,
          'name': 'Kilogram',
          'code': 'kg',
          'coefficient': 1.0,
          'valueType': 5,
          'minValue': 0,
          'unitGroupId': massGroupId,
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
          'unitGroupId': massGroupId,
          'invertible': true,
          'oob': false
        },
        'paramSetId': 4
      },
      'calculated': false
    }
  ]
};

// need to get a new instance for a new test in order to 'reset' values streams
ConversionParamSetValueModel _barbellWeightParamSetValue() {
  return const ConversionParamSetValueModel(
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
}

void main() {
  test('Serialize param set value', () {
    expect(_barbellWeightParamSetValue().toJson(), _paramSetValueJson);
  });

  test('Deserialize param set value', () {
    expect(
      ConversionParamSetValueModel.fromJson(_paramSetValueJson),
      _barbellWeightParamSetValue(),
    );
  });

  test('Copy with changed list param value', () async {
    expect(
      await _barbellWeightParamSetValue().copyWithChangedParams(
        map: (paramValue, paramSetValue) async => paramValue.copyWith(
          value: Patchable(ValueModel.num(20)),
        ),
        paramFilter: (paramValue) => paramValue.param.id == barWeightParam.id,
      ),
      ConversionParamSetValueModel(
        paramSet: barbellWeightParamSet,
        paramValues: [
          ConversionParamValueModel(
            param: barWeightParam,
            value: ValueModel.num(20),
          ),
          const ConversionParamValueModel(
            param: oneSideWeightParam,
          ),
        ],
      ),
    );
  });

  test('Copy with changed non-list param value', () async {
    expect(
      await _barbellWeightParamSetValue().copyWithChangedParams(
        map: (paramValue, paramSetValue) async => paramValue.copyWith(
          value: Patchable(ValueModel.num(40)),
        ),
        paramFilter: (paramValue) =>
            paramValue.param.id == oneSideWeightParam.id,
      ),
      ConversionParamSetValueModel(
        paramSet: barbellWeightParamSet,
        paramValues: [
          const ConversionParamValueModel(
            param: barWeightParam,
          ),
          ConversionParamValueModel(
            param: oneSideWeightParam,
            value: ValueModel.num(40),
          ),
        ],
      ),
    );
  });

  test('Copy with changed unknown param', () async {
    final barbellWeight = _barbellWeightParamSetValue();

    expect(
      await barbellWeight.copyWithChangedParams(
        map: (paramValue, paramSetValue) async => paramValue.copyWith(
          value: Patchable(ValueModel.num(40)),
        ),
        paramFilter: (paramValue) => paramValue.param.id == -1,
      ),
      barbellWeight,
    );
  });

  test('Check whether it has multiple calculable params', () {
    expect(_barbellWeightParamSetValue().hasMultipleCalculableParams, false);

    expect(
      _paramSetValueWithMultipleCalculableParams.hasMultipleCalculableParams,
      true,
    );
  });

  test('Switch on the calculable param first time', () {
    expect(
      _barbellWeightParamSetValue().copyWithNewCalculatedParam(
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
