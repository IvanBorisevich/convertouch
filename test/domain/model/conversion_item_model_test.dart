import 'package:convertouch/domain/model/conversion_item_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:test/test.dart';

void main() {
  ConversionItemModel item = ConversionItemModel(
    unit: const UnitModel(
      name: "testUnitName",
      code: "testUnitCode",
    ),
    value: ValueModel.ofDouble(0.00009),
    defaultValue: ValueModel.ofDouble(0.008),
  );

  Map<String, dynamic> itemJson = {
    "unit": {
      "name": "testUnitName",
      "code": "testUnitCode",
      "invertible": true,
    },
    "value": {
      "raw": "0",
      "scientific": "9 · 10¯⁵",
    },
    "defaultValue": {
      "raw": "0.008",
      "scientific": "0.008",
    },
  };

  test('Serialize conversion item', () {
    expect(item.toJson(), itemJson);
  });

  test('Deserialize conversion item', () {
    expect(ConversionItemModel.fromJson(itemJson), item);
  });
}
