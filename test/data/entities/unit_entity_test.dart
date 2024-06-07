import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Build units table row from entity with init defaults',
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
    'Build units table row from entity without init defaults',
    () {
      expect(
        UnitEntity.entityToRow(
          {
            "code": "g",
          },
          unitGroupId: 1,
          initDefaults: false,
        ),
        {
          'code': 'g',
        },
      );

      expect(
        UnitEntity.entityToRow(
          {
            "code": "g",
            "coefficient": null,
          },
          unitGroupId: 1,
          initDefaults: false,
        ),
        {
          'code': 'g',
          'coefficient': null,
        },
      );
    },
  );
}
