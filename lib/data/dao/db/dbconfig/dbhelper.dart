import 'dart:developer';

import 'package:convertouch/domain/constants/default_units.dart';
import 'package:convertouch/data/dao/db/dbconfig/dbconfig.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/di.dart' as di;
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite/sqflite.dart';


/// How to upgrade DB structure and content:
/// 1) Increase dbVersion
/// 2) Add new units map (if needed) to the unitDataVersions list
/// 3) Add new Migration to the migrations list
/// 4) Run in the terminal any of the commands:
///   - dart run build_runner build
///   - flutter packages pub run build_runner build
/// 5) Rebuild and start the app
class ConvertouchDatabaseHelper {
  static final ConvertouchDatabaseHelper I =
  di.locator.get<ConvertouchDatabaseHelper>();

  Future<ConvertouchDatabase> initDatabase() async {
    log("Initializing database ${ConvertouchDatabase.databaseName}");
    return $FloorConvertouchDatabase
        .databaseBuilder(ConvertouchDatabase.databaseName)
        .addCallback(initialization)
        .addMigrations(migrations)
        .build();
  }

  Future<void> fillDatabaseWithUnits(
      sqflite.Database database,
      List<dynamic> entities,
      ) async {
    for (Map<String, dynamic> entity in entities) {
      database.transaction((transaction) async {
        int groupId = await transaction.insert(unitGroupsTableName, {
          'name': entity['groupName'],
          'icon_name': entity['iconName'],
          'conversion_type': entity['conversionType'],
          'refreshable': entity['refreshable'],
        });
        for (Map<String, dynamic> unit in entity['units']) {
          transaction.insert(
            unitsTableName,
            {
              'name': unit['name'],
              'abbreviation': unit['abbreviation'],
              'coefficient': unit['coefficient'],
              'unit_group_id': groupId,
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      });
    }
  }
}

final initialization = Callback(
  onCreate: (database, version) {
    log("[onCreate] Current database version: $version");
    for (int version = 1; version <= dbVersion; version++) {
      log("[onCreate] Initialization units of version $version");
      ConvertouchDatabaseHelper.I.fillDatabaseWithUnits(
        database,
        unitDataVersions[version - 1],
      );
    }
  },
);

final migrations = [
  migration1to2,
];

final migration1to2 = Migration(1, 2, (database) async {
  log("Migration database from version 1 to 2");
});