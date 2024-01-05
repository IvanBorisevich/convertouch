import 'dart:developer';

import 'package:convertouch/data/dao/db/dbconfig/dbconfig.dart';
import 'package:convertouch/data/dao/db/dbconfig/migrations/v1_init.dart';
import 'package:convertouch/di.dart' as di;
import 'package:floor/floor.dart';

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
}

final initialization = Callback(
  onCreate: (database, version) {
    log("[onCreate] Current database version: $version");
    for (int version = 1; version <= dbVersion; version++) {
      log("[onCreate] Initialization units of version $version");
      InitialMigration().execute(database);
    }
  },
);

final migrations = [
  migration1to2,
];

final migration1to2 = Migration(1, 2, (database) async {
  log("Migration database from version 1 to 2");
});
