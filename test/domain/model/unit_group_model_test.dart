import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:test/test.dart';

void main() {
  const UnitGroupModel unitGroup = UnitGroupModel(
    id: 1,
    name: 'Money',
    valueType: ConvertouchValueType.decimalPositive,
  );

  const Map<String, dynamic> unitGroupJson = {
    'id': 1,
    'name': 'Money',
    'conversionType': 0,
    'refreshable': false,
    'valueType': 5,
    'oob': false,
  };

  test('Serialize unit group', () {
    expect(unitGroup.toJson(), unitGroupJson);
  });

  test('Deserialize unit group', () {
    expect(UnitGroupModel.fromJson(unitGroupJson), unitGroup);
  });
}
