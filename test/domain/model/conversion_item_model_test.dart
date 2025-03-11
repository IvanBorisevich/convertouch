import 'package:convertouch/domain/model/conversion_item_value_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

void main() {
  ConversionUnitValueModel item = ConversionUnitValueModel(
    unit: const UnitModel(
      name: "testUnitName",
      code: "testUnitCode",
    ),
    value: ValueModel.numeric(0.00009),
    defaultValue: ValueModel.numeric(0.008),
  );

  Map<String, dynamic> itemJson = {
    "unit": {
      "id": -1,
      "name": "testUnitName",
      "code": "testUnitCode",
      "valueType": 4,
      "invertible": true,
    },
    "value": {
      "raw": "0.00009",
      "alt": "9 · 10¯⁵",
      "num": 0.00009,
      "listType": null,
    },
    "defaultValue": {
      "raw": "0.008",
      "alt": "0.008",
      "num": 0.008,
      "listType": null,
    },
  };

  test('Serialize conversion item', () {
    expect(item.toJson(), itemJson);
  });

  test('Deserialize conversion item', () {
    final actual = ConversionUnitValueModel.fromJson(itemJson);
    expect(actual?.unit.id, item.unit.id);
    expect(actual?.unit.name, item.unit.name);
    expect(actual?.unit.code, item.unit.code);
    expect(actual?.value, item.value);
    expect(actual?.defaultValue, item.defaultValue);
  });
}
