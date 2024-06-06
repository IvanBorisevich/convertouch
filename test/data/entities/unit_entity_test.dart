import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Build units table row from entity with auto set defaults',
    () {
      expect(
        UnitEntity.entityToRow(
          {
            "code": "g",
            "name": "Gram",
            "coefficient": 0.001,
          },
          unitGroupId: 1,
        ),
        {
          'name': 'Gram',
          'code': 'g',
          'coefficient': 0.001,
          'symbol': null,
          'unit_group_id': 1,
          'value_type': null,
          'min_value': null,
          'max_value': null,
          'invertible': null,
          'oob': 1,
        },
      );
    },
  );

  test(
    'Build units table row from entity without auto set defaults',
    () {
      expect(
        UnitEntity.entityToRow(
          {
            "code": "g",
          },
          unitGroupId: 1,
          autoSetDefaults: false,
        ),
        {
          'code': 'g',
          'name': null,
          'coefficient': null,
          'symbol': null,
          'unit_group_id': 1,
          'value_type': null,
          'min_value': null,
          'max_value': null,
          'invertible': null,
          'oob': null,
        },
      );
    },
  );
}
