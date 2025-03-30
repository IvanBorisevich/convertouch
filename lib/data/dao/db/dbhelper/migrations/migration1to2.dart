import 'dart:developer';

import 'package:convertouch/data/const/oob_units.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration.dart';
import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:sqflite/sqflite.dart';

class Migration1to2 extends ConvertouchDbMigration {
  @override
  Future<void> execute(Database database) async {
    log("Migration database from version 1 to 2");

    bool columnNew = await SqlUtils.isColumnNew(
      database,
      tableName: 'units',
      columnName: 'invertible',
    );

    if (columnNew) {
      await database.execute("ALTER TABLE units ADD COLUMN invertible INTEGER");
    }

    await SqlUtils.mergeGroupsAndUnits(
      database,
      items: unitsV2,
    );
  }
}
