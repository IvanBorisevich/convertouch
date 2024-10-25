import 'dart:developer';

import 'package:convertouch/data/const/oob_units.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration.dart';
import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:sqflite/sqflite.dart';

class InitialMigration extends ConvertouchDbMigration {
  @override
  Future<void> execute(Database database) async {
    log("Initial migration database for version 1");
    await SqlUtils.mergeGroupsAndUnits(
      database,
      entities: unitsV1,
    );
  }
}
