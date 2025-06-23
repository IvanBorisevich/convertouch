import 'dart:developer';

import 'package:convertouch/data/const/oob_units.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration.dart';
import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:sqflite/sqflite.dart';

class Migration4to5 extends ConvertouchDbMigration {

  @override
  Future<void> execute(Database database) async {
    log("Migration database from version 4 to 5");

    await SqlUtils.mergeGroupsAndUnits(
      database,
      items: unitsV5,
    );
  }
}
