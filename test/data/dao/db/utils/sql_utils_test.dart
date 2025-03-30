import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

Future<void> main() async {
  sqfliteFfiInit();

  var databaseFactory = databaseFactoryFfi;

  test('Check select queries with list args', () {
    expect(
      SqlUtils.toInArgsQuery(
        'select * from units where id in (?)',
        [
          [1, 2]
        ],
      ),
      'select * from units where id in (?,?)',
    );

    expect(
      SqlUtils.toInArgsQuery(
        'select * from units where id in (?)',
        [
          [1]
        ],
      ),
      'select * from units where id in (?)',
    );

    expect(
      SqlUtils.toInArgsQuery('select * from units where id in (?)', [1]),
      'select * from units where id in (?)',
    );

    expect(
      SqlUtils.toInArgsQuery(
        'select * from units where code in (?)',
        [
          ['code1', 'code2']
        ],
      ),
      'select * from units where code in (?,?)',
    );

    expect(
      SqlUtils.toInArgsQuery(
        'SELECT id FROM units WHERE unit_group_id = ? AND code in (?)',
        [
          1,
          ['code1', 'code2']
        ],
      ),
      'SELECT id FROM units WHERE unit_group_id = ? AND code in (?,?)',
    );

    expect(
      SqlUtils.toInArgsQuery(
        'SELECT id FROM units WHERE unit_group_id in (?) AND code in (?)',
        [
          [1, 2],
          ['code1', 'code2']
        ],
      ),
      'SELECT id FROM units WHERE unit_group_id in (?,?) AND code in (?,?)',
    );
  });

  test('Execute select queries', () async {
    var db = await databaseFactory.openDatabase(inMemoryDatabasePath);

    await db.execute('''
      CREATE TABLE IF NOT EXISTS `unit_groups` (
        `name` TEXT NOT NULL, 
        `icon_name` TEXT, 
        `conversion_type` INTEGER, 
        `refreshable` INTEGER, 
        `value_type` INTEGER NOT NULL, 
        `min_value` REAL, 
        `max_value` REAL, 
        `oob` INTEGER, 
        `id` INTEGER PRIMARY KEY AUTOINCREMENT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS `units` (
        `name` TEXT NOT NULL, 
        `code` TEXT NOT NULL, 
        `symbol` TEXT, 
        `coefficient` REAL, 
        `unit_group_id` INTEGER NOT NULL, 
        `value_type` INTEGER, 
        `min_value` REAL, 
        `max_value` REAL, 
        `invertible` INTEGER, 
        `oob` INTEGER, 
        `id` INTEGER PRIMARY KEY AUTOINCREMENT, 
        FOREIGN KEY (`unit_group_id`) REFERENCES `unit_groups` (`id`) 
          ON UPDATE NO ACTION ON DELETE CASCADE
      )
    ''');

    int groupId = await db.insert('unit_groups', {
      'name': 'group1',
      'value_type': ConvertouchValueType.decimal.val,
    });

    List<int> unitIds = [];

    for (int i = 1; i <= 2; i++) {
      int unitId = await db.insert('units', {
        'name': 'unit$i',
        'code': 'code$i',
        'unit_group_id': groupId,
      });

      unitIds.add(unitId);
    }

    expect(
      await db.rawQuery('select count(1) as c from units'),
      [
        {'c': 2}
      ],
    );

    expect(
      await db.transaction((txn) async {
        return await SqlUtils.selectSingles(
          txn: txn,
          query: getUnitIdsByCodesAndGroupName,
          args: [
            'group1',
            ['code1', 'code2'],
          ],
        );
      }),
      unitIds,
    );

    expect(
      await db.transaction((txn) async {
        return await SqlUtils.selectPairs(
          txn: txn,
          query: getGroups,
        );
      }),
      {
        'group1': 1,
      },
    );

    expect(
      await db.transaction((txn) async {
        return await SqlUtils.selectPairs(
          txn: txn,
          query: getUnitCodesByGroupId,
          args: [groupId],
          kFunc: (item) => item['code'],
          vFunc: (item) => item['id'],
        );
      }),
      {
        'code1': 1,
        'code2': 2,
      },
    );

    expect(
      await db.transaction((txn) async {
        return await SqlUtils.selectSingles(
          txn: txn,
          query: getUnitIdsByCodesAndGroupName,
          args: [
            'group1',
            ['code1', 'code2'],
          ],
        );
      }),
      [1, 2],
    );

    await db.close();
  });

  test('Build queries for update', () {
    expect(
      SqlUtils.buildQueryForUpdate(
        tableName: unitGroupsTableName,
        id: 1,
        row: {
          'name': 'New Group',
          'icon_name': 'New Icon',
        },
      ).sqlQuery,
      "UPDATE unit_groups SET "
      "name = ?, "
      "icon_name = ? "
      "WHERE id = 1",
    );

    expect(
      SqlUtils.buildQueryForUpdate(
        tableName: unitGroupsTableName,
        id: 1,
        row: {
          'icon_name': 'New Icon',
          'min_value': 2,
        },
      ).sqlQuery,
      "UPDATE unit_groups SET "
      "icon_name = ?, "
      "min_value = ? "
      "WHERE id = 1",
    );

    expect(
      SqlUtils.buildQueryForUpdate(
        tableName: unitGroupsTableName,
        id: 1,
        row: {
          'name': 'New Group',
          'icon_name': 'New Icon',
          'refreshable': 1,
        },
      ).sqlQuery,
      "UPDATE unit_groups SET "
      "name = ?, "
      "icon_name = ?, "
      "refreshable = ? "
      "WHERE id = 1",
    );
  });

  test('Build empty query if no data to be updated', () {
    expect(
      SqlUtils.buildQueryForUpdate(
        tableName: unitGroupsTableName,
        id: 1,
        row: {},
      ).sqlQuery,
      null,
    );

    expect(
      SqlUtils.buildQueryForUpdate(
        tableName: unitGroupsTableName,
        id: 1,
        row: UnitGroupEntity.jsonToRow({}, excludedColumns: ['oob']),
      ).sqlQuery,
      null,
    );
  });
}
