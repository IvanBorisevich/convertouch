import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Build queries for update',
    () {
      expect(
        SqlUtils.buildUpdateQuery(
          tableName: unitGroupsTableName,
          id: 1,
          row: {
            'name': 'Length',
            'icon_name': 'length-group.png',
          },
        ),
        "UPDATE unit_groups SET "
        "name = 'Length', "
        "icon_name = 'length-group.png' "
        "WHERE id = 1",
      );

      expect(
        SqlUtils.buildUpdateQuery(
          tableName: unitGroupsTableName,
          id: 1,
          row: {
            'name': 'Length',
            'icon_name': 'length-group.png',
          },
          excludedColumns: ['name'],
        ),
        "UPDATE unit_groups SET "
        "icon_name = 'length-group.png' "
        "WHERE id = 1",
      );

      expect(
        SqlUtils.buildUpdateQuery(
          tableName: unitGroupsTableName,
          id: 1,
          row: {
            'name': 'Length',
            'icon_name': 'length-group.png',
            'min_value': null,
          },
          excludedColumns: ['name'],
        ),
        "UPDATE unit_groups SET "
            "icon_name = 'length-group.png', "
            "min_value = null "
            "WHERE id = 1",
      );

      expect(
        SqlUtils.buildUpdateQuery(
          tableName: unitGroupsTableName,
          id: 1,
          row: {
            'name': 'Length',
            'icon_name': 'length-group.png',
            'refreshable': 1,
          },
        ),
        "UPDATE unit_groups SET "
        "name = 'Length', "
        "icon_name = 'length-group.png', "
        "refreshable = 1 "
        "WHERE id = 1",
      );

      expect(
        SqlUtils.buildUpdateQuery(
          tableName: unitGroupsTableName,
          id: 1,
          row: {
            'name': 'Length',
            'icon_name': 'length-group.png',
            'refreshable': 1,
            'oob': 1,
          },
          excludedColumns: ['oob'],
        ),
        "UPDATE unit_groups SET "
        "name = 'Length', "
        "icon_name = 'length-group.png', "
        "refreshable = 1 "
        "WHERE id = 1",
      );

      expect(
        SqlUtils.buildUpdateQuery(
          tableName: unitsTableName,
          id: 1,
          row: {
            'name': 'Gram',
            'code': 'g',
            'coefficient': 0.001,
            'unit_group_id': 1,
            'oob': 1,
          },
        ),
        "UPDATE units SET "
        "name = 'Gram', "
        "code = 'g', "
        "coefficient = 0.001, "
        "unit_group_id = 1, "
        "oob = 1 "
        "WHERE id = 1",
      );
    },
  );

  test(
    'Not build queries for update if no data to be updated',
    () {
      expect(
        SqlUtils.buildUpdateQuery(
          tableName: unitGroupsTableName,
          id: 1,
          row: {},
        ),
        null,
      );

      expect(
        SqlUtils.buildUpdateQuery(
          tableName: unitGroupsTableName,
          id: 1,
          row: {
            'name': 'Any Group',
          },
          excludedColumns: ['name'],
        ),
        null,
      );

      expect(
        SqlUtils.buildUpdateQuery(
          tableName: unitsTableName,
          id: 1,
          row: {},
        ),
        null,
      );

      expect(
        SqlUtils.buildUpdateQuery(
          tableName: unitsTableName,
          id: 1,
          row: {
            'code': 'Any Unit Code',
            'oob': 1,
          },
          excludedColumns: ['code', 'oob'],
        ),
        null,
      );
    },
  );
}
