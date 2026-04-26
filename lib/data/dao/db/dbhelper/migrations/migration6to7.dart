import 'dart:developer';

import 'package:convertouch/data/const/oob_params.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration.dart';
import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:sqflite/sqflite.dart';

class Migration6to7 extends ConvertouchDbMigration {
  @override
  Future<void> execute(Database database) async {
    log("Migration database from version 6 to 7");

    await SqlUtils.mergeConversionParams(
      database,
      items: conversionParamsV2,
    );
  }
}
