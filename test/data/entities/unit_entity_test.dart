import 'package:convertouch/data/entities/entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Build units table row from entity for insert',
    () {
      expect(
        UnitEntity.jsonToRow(
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
          'unit_group_id': 1,
          'oob': 1,
        },
      );

      expect(
        UnitEntity.jsonToRow(
          {
            "code": CountryCode.it,
            "name": "Italy",
          },
          unitGroupId: 10,
        ),
        {
          'name': 'Italy',
          'code': 'IT',
          'unit_group_id': 10,
          'oob': 1,
        },
      );
    },
  );

  test(
    'Build units table row from entity for update',
    () {
      expect(
        UnitEntity.jsonToRow(
          {
            "code": "g",
            forUpdate: {
              "name": "Gram",
              "coefficient": 0.001,
              "invertible": false,
            }
          },
          unitGroupId: 1,
        ),
        {
          'name': 'Gram',
          'coefficient': 0.001,
          'unit_group_id': 1,
          'invertible': 0,
          'oob': 1,
        },
      );

      expect(
        UnitEntity.jsonToRow(
          {
            "code": "g",
            forUpdate: {
              "name": "Gram",
              "coefficient": 0.001,
              "minValue": -1,
            }
          },
          unitGroupId: 2,
        ),
        {
          'name': 'Gram',
          'coefficient': 0.001,
          'unit_group_id': 2,
          'min_value': null,
          'oob': 1,
        },
      );

      expect(
        UnitEntity.jsonToRow(
          {
            "code": "g",
            forUpdate: {
              "name": "Gram",
              "coefficient": 0.001,
              "minValue": -1,
            }
          },
          unitGroupId: -1,
        ),
        {
          'name': 'Gram',
          'coefficient': 0.001,
          'unit_group_id': null,
          'min_value': null,
          'oob': 1,
        },
      );

      expect(
        UnitEntity.jsonToRow({}, unitGroupId: null, excludedColumns: ['oob']),
        {},
      );
    },
  );
}
