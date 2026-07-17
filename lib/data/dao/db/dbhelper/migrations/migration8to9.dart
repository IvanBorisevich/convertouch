import 'dart:developer';

import 'package:convertouch/data/const/oob_units.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration.dart';
import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:sqflite/sqflite.dart';

class Migration8to9 extends ConvertouchDbMigration {
  const Migration8to9();

  @override
  Future<void> execute(Database database) async {
    log("Migration database from version 8 to 9");

    await SqlUtils.mergeGroupsAndUnits(
      database,
      items: unitsV8,
    );
  }
}
