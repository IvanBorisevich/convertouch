import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Build unit_groups table row from entity with auto set defaults',
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
    'Build unit_groups table row from entity without auto set defaults',
    () {
      expect(
        UnitGroupEntity.entityToRow(
          {
            'groupName': 'Length',
          },
          autoSetDefaults: false,
        ),
        {
          'name': 'Length',
          'icon_name': null,
          'conversion_type': null,
          'refreshable': null,
          'value_type': null,
          'min_value': null,
          'max_value': null,
          'oob': null
        },
      );
    },
  );
}
