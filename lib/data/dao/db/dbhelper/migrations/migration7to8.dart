import 'dart:developer';

import 'package:convertouch/data/const/oob_units.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration.dart';
import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:sqflite/sqflite.dart';

class Migration7to8 extends ConvertouchDbMigration {
  const Migration7to8();

  @override
  Future<void> execute(Database database) async {
    log("Migration database from version 7 to 8");

    await SqlUtils.mergeGroupsAndUnits(
      database,
      items: unitsV7,
    );
  }
}
