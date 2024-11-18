import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:test/test.dart';

void main() {
  test('Build queries for update', () {
    expect(
      SqlUtils.buildUpdateQuery(
        tableName: unitGroupsTableName,
        id: 1,
        columnNamesToUpdate: ['name', 'icon_name'],
      ),
      "UPDATE unit_groups SET "
      "name = ?, "
      "icon_name = ? "
      "WHERE id = 1",
    );

    expect(
      SqlUtils.buildUpdateQuery(
        tableName: unitGroupsTableName,
        id: 1,
        columnNamesToUpdate: ['icon_name', 'min_value'],
      ),
      "UPDATE unit_groups SET "
      "icon_name = ?, "
      "min_value = ? "
      "WHERE id = 1",
    );

    expect(
      SqlUtils.buildUpdateQuery(
        tableName: unitGroupsTableName,
        id: 1,
        columnNamesToUpdate: ['name', 'icon_name', 'refreshable'],
      ),
      "UPDATE unit_groups SET "
      "name = ?, "
      "icon_name = ?, "
      "refreshable = ? "
      "WHERE id = 1",
    );
  });

  test('Not build queries for update if no data to be updated', () {
    expect(
      SqlUtils.buildUpdateQuery(
        tableName: unitGroupsTableName,
        id: 1,
        columnNamesToUpdate: [],
      ),
      null,
    );
  });
}
