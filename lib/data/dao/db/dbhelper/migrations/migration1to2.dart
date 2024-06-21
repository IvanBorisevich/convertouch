import 'dart:developer';

import 'package:convertouch/data/dao/db/dbhelper/migration.dart';
import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:convertouch/domain/constants/default_units.dart';
import 'package:sqflite/sqflite.dart';

class Migration1to2 extends ConvertouchDbMigration {
  @override
  Future<void> execute(Database database) async {
    log("Migration database from version 1 to 2");
    if (await SqlUtils.isColumnNew(
      database,
      tableName: 'units',
      columnName: 'invertible',
    )) {
      await database.execute("ALTER TABLE units ADD COLUMN invertible INTEGER");
    }
    await SqlUtils.updateUnitColumn(
      database,
      unitCode: 'cm',
      groupName: 'Volume',
      columnName: 'code',
      newColumnValue: 'cm³',
    );
    await SqlUtils.mergeGroupsAndUnits(
      database,
      entities: unitsV2,
    );
  }
}
