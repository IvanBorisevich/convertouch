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
    value: ValueModel.ofDouble(0.00009),
    defaultValue: ValueModel.ofDouble(0.008),
  );

  Map<String, dynamic> itemJson = {
    "unit": {
      "id": -1,
      "name": "testUnitName",
      "code": "testUnitCode",
      "invertible": true,
    },
    "value": {
      "num": 0.00009,
      "raw": "0.00009",
      "scientific": "9 · 10¯⁵",
    },
    "defaultValue": {
      "num": 0.008,
      "raw": "0.008",
      "scientific": "0.008",
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
