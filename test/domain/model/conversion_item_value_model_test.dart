import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

void main() {
  group('For conversion param value', () {
    const ConversionParamValueModel paramValue = ConversionParamValueModel(
      param: ConversionParamModel(
        id: 1,
        name: 'Height',
        unitGroupId: 1,
        valueType: ConvertouchValueType.decimalPositive,
        paramSetId: 1,
      ),
      unit: UnitModel(
        id: 1,
        name: 'Meter',
        code: 'm',
        valueType: ConvertouchValueType.decimalPositive,
      ),
      value: ValueModel.one,
      defaultValue: ValueModel.one,
    );

    const Map<String, dynamic> paramValueJson = {
      'param': {
        'id': 1,
        'name': 'Height',
        'unitGroupId': 1,
        'valueType': 5,
        'paramSetId': 1,
        'calculable': false,
      },
      'unit': {
        "id": 1,
        "name": 'Meter',
        "code": 'm',
        "valueType": 5,
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
      expect(paramValue.toJson(), paramValueJson);
    });

    test('Deserialize param value', () {
      expect(ConversionParamValueModel.fromJson(paramValueJson), paramValue);
    });
  });

  group('For conversion unit value', () {
    const ConversionUnitValueModel unitValue = ConversionUnitValueModel(
      unit: UnitModel(
        id: 1,
        name: 'Meter',
        code: 'm',
        valueType: ConvertouchValueType.decimalPositive,
      ),
      value: ValueModel.one,
      defaultValue: ValueModel.one,
    );

    const Map<String, dynamic> unitValueJson = {
      'unit': {
        "id": 1,
        "name": 'Meter',
        "code": 'm',
        "valueType": 5,
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
