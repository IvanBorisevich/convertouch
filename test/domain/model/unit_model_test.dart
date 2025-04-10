import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:test/test.dart';

void main() {
  const UnitModel unit = UnitModel(
    id: 1,
    name: 'Meter',
    code: 'm',
    valueType: ConvertouchValueType.decimalPositive,
  );

  const Map<String, dynamic> unitJson = {
    'id': 1,
    'name': 'Meter',
    'code': 'm',
    'valueType': 5,
    'invertible': true,
    'oob': false,
  };

  test('Serialize unit', () {
    expect(unit.toJson(), unitJson);
  });

  test('Deserialize unit', () {
    expect(UnitModel.fromJson(unitJson), unit);
  });
}
