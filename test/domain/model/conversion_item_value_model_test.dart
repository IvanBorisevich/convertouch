import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/conversion_param_constants/clothing_size.dart';
import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/conversion_param_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

void main() {
  const UnitModel unit = UnitModel(
    id: 1,
    name: 'Meter',
    code: 'm',
    valueType: ConvertouchValueType.decimalPositive,
  );

  const UnitModel listUnit = UnitModel(
    id: 1,
    name: 'Clothing Size US',
    code: 'US',
    valueType: ConvertouchValueType.decimalPositive,
    listType: ConvertouchListType.clothingSizeUs,
  );

  group('For conversion param value', () {
    const ConversionParamModel param = ConversionParamModel(
      id: 1,
      name: 'Height',
      unitGroupId: 1,
      valueType: ConvertouchValueType.decimalPositive,
      paramSetId: 1,
    );

    const ConversionParamModel listParam = ConversionParamModel(
      id: 1,
      name: 'Clothing Size Int',
      unitGroupId: 1,
      valueType: ConvertouchValueType.decimalPositive,
      listType: ConvertouchListType.clothingSizeInter,
      paramSetId: 1,
    );

    const ConversionParamValueModel paramValue = ConversionParamValueModel(
      param: param,
      unit: unit,
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

    test('Build param value from a raw string value', () {
      expect(
        ConversionParamValueModel.wrap(
          param: param,
          value: null,
          defaultValue: null,
        ),
        const ConversionParamValueModel(
          param: param,
          defaultValue: ValueModel.one,
        ),
      );

      expect(
        ConversionParamValueModel.wrap(
          param: listParam,
          value: null,
          defaultValue: null,
        ),
        ConversionParamValueModel(
          param: listParam,
          defaultValue: ValueModel.str(ClothingSizeInter.values.first.name),
        ),
      );
    });
  });

  group('For conversion unit value', () {
    const ConversionUnitValueModel unitValue = ConversionUnitValueModel(
      unit: unit,
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

    test('Build unit value from a raw string value', () {
      expect(
        ConversionUnitValueModel.wrap(
          unit: unit,
          value: null,
          defaultValue: null,
        ),
        const ConversionUnitValueModel(
          unit: unit,
          value: null,
          defaultValue: ValueModel.one,
        ),
      );

      expect(
        ConversionUnitValueModel.wrap(
          unit: listUnit,
          value: null,
          defaultValue: null,
        ),
        ConversionUnitValueModel(
          unit: listUnit,
          defaultValue: ValueModel.numeric(2),
        ),
      );
    });
  });
}
