import 'dart:developer';

import 'package:convertouch/data/const/oob_params.dart';
import 'package:convertouch/data/const/oob_units.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration.dart';
import 'package:convertouch/data/dao/db/utils/sql_utils.dart';
import 'package:sqflite/sqflite.dart';

class Migration7to8 extends ConvertouchDbMigration {
  const Migration7to8();

  @override
  Future<void> execute(Database database) async {
    log("Migration database from version 7 to 8");

    bool columnNew = await SqlUtils.isColumnNew(
      database,
      tableName: 'conversion_param_sets',
      columnName: 'icon_name',
    );

    if (columnNew) {
      await database.execute(
        "ALTER TABLE conversion_param_sets ADD COLUMN icon_name TEXT",
      );
    }

    await SqlUtils.mergeGroupsAndUnits(
      database,
      items: unitsV7,
    );

    await SqlUtils.mergeConversionParams(
      database,
      items: conversionParamsV3,
    );
  }
}
