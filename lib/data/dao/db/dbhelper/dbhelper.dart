import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:convertouch/data/dao/db/dbhelper/dbconfig/dbconfig.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/init_migration.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration1to2.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration2to3.dart';
import 'package:convertouch/data/dao/db/dbhelper/migrations/migration3to4.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/main.dart';
import 'package:floor/floor.dart';

/// How to upgrade DB structure and content:
/// 1) Increase database version
/// 2) Add new units map (if needed) to the unitDataVersions list
/// 3) Add new migration to the _rawMigrations list
/// 4) Run in the terminal any of the commands:
///   - dart run build_runner build
///   - flutter packages pub run build_runner build
/// 5) Rebuild and start the app

class ConvertouchDatabaseHelper {
  static const databaseName = "convertouch_database.db";
  static const databaseVersion = 4;

  static final ConvertouchDatabaseHelper I =
      di.locator.get<ConvertouchDatabaseHelper>();

  Future<ConvertouchDatabase> initDatabase() async {
    logger.d("Initializing database $databaseName "
        "of version ${ConvertouchDatabaseHelper.databaseVersion}");
    final migrations = await _initMigrations();
    return await $FloorConvertouchDatabase
        .databaseBuilder(databaseName)
        .addCallback(_initCallback)
        .addMigrations(migrations)
        .build();
  }

  Future<List<Migration>> _initMigrations() async {
    return _rawMigrations
        .mapIndexed(
          (index, e) => Migration(index + 1, index + 2, (database) async {
            e.execute(database);
          }),
        )
        .toList();
  }
}

final _initCallback = Callback(
  onCreate: (database, version) async {
    log("[onCreate] Current database version: $version");
    await InitialMigration().execute(database);
    for (int ver = 1; ver < version; ver++) {
      await _rawMigrations[ver - 1].execute(database);
    }
  },
);

final List<ConvertouchDbMigration> _rawMigrations = [
  Migration1to2(),
  Migration2to3(),
  Migration3to4(),
];
