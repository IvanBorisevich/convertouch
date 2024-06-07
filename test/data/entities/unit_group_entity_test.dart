import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Build unit_groups table row from entity with init defaults',
    () {
      expect(
        UnitGroupEntity.entityToRow({
          'groupName': 'Length',
          'iconName': 'length-group.png',
          'valueType': ConvertouchValueType.decimalPositive,
          'minValue': 0,
        }),
        {
          'name': 'Length',
          'icon_name': 'length-group.png',
          'conversion_type': null,
          'refreshable': null,
          'value_type': ConvertouchValueType.decimalPositive.val,
          'min_value': 0,
          'max_value': null,
          'oob': 1,
        },
      );

      expect(
        UnitGroupEntity.entityToRow({
          'groupName': 'Length',
          'iconName': 'length-group.png',
          'conversionType': ConversionType.static,
          'refreshable': false,
          'valueType': ConvertouchValueType.decimalPositive,
          'minValue': 0,
          'units': [],
        }),
        {
          'name': 'Length',
          'icon_name': 'length-group.png',
          'conversion_type': null,
          'refreshable': null,
          'value_type': ConvertouchValueType.decimalPositive.val,
          'min_value': 0,
          'max_value': null,
          'oob': 1,
        },
      );
    },
  );

  test(
    'Build unit_groups table row from entity without init defaults',
    () {
      expect(
        UnitGroupEntity.entityToRow(
          {
            'groupName': 'Length',
          },
          initDefaults: false,
        ),
        {
          'name': 'Length',
        },
      );

      expect(
        UnitGroupEntity.entityToRow(
          {
            'groupName': 'Length',
            'minValue': null,
            'units': [],
          },
          initDefaults: false,
        ),
        {
          'name': 'Length',
          'min_value': null,
        },
      );
    },
  );
}
