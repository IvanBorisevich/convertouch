import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Build unit_groups table row from entity',
    () {
      expect(
        UnitGroupEntity.jsonToRow({
          'groupName': 'Length',
          'iconName': 'length-group.png',
          'valueType': ConvertouchValueType.decimalPositive,
          'minValue': 0,
        }),
        {
          'name': 'Length',
          'icon_name': 'length-group.png',
          'value_type': ConvertouchValueType.decimalPositive.id,
          'min_value': 0,
          'oob': 1,
        },
      );

      expect(
        UnitGroupEntity.jsonToRow({
          'groupName': 'Length',
          'iconName': 'length-group.png',
          'valueType': ConvertouchValueType.decimalPositive,
          'minValue': 0,
          'oob': true,
        }),
        {
          'name': 'Length',
          'icon_name': 'length-group.png',
          'value_type': ConvertouchValueType.decimalPositive.id,
          'min_value': 0,
          'oob': 1,
        },
      );

      expect(
        UnitGroupEntity.jsonToRow({
          'groupName': 'Length',
          'iconName': 'length-group.png',
          'refreshable': false,
          'valueType': ConvertouchValueType.decimalPositive,
          'minValue': 0,
          'units': [],
          'oob': null,
        }),
        {
          'name': 'Length',
          'icon_name': 'length-group.png',
          'refreshable': 0,
          'value_type': ConvertouchValueType.decimalPositive.id,
          'min_value': 0,
          'oob': 1,
        },
      );

      expect(
        UnitGroupEntity.jsonToRow({
          'groupName': 'Length',
          'iconName': 'length-group.png',
          'valueType': ConvertouchValueType.decimalPositive,
          'minValue': 0,
          'oob': false,
        }),
        {
          'name': 'Length',
          'icon_name': 'length-group.png',
          'value_type': ConvertouchValueType.decimalPositive.id,
          'min_value': 0,
          'oob': 0,
        },
      );

      expect(
        UnitGroupEntity.jsonToRow({
          'groupName': 'Length',
          'iconName': 'length-group.png',
          'valueType': null,
          'minValue': -1,
          'oob': false,
        }, excludedColumns: [
          'oob'
        ]),
        {
          'name': 'Length',
          'icon_name': 'length-group.png',
          'min_value': null,
        },
      );

      expect(UnitGroupEntity.jsonToRow({}, excludedColumns: ['oob']), {});
    },
  );
}
