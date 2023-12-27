import 'dart:developer';

import 'package:convertouch/data/dao/db/dbconfig/dbconfig.dart';
import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/di.dart' as di;
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/constants/default_units.dart';
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

  Future<void> fillDatabase(
    sqflite.Database database,
    List<dynamic> entities,
  ) async {
    for (Map<String, dynamic> entity in entities) {
      database.transaction(
        (txn) async {
          int unitGroupId = await _insertGroup(txn, entity);
          List<int> unitIds = await _insertUnits(txn, unitGroupId, entity);

          bool valuesAreRefreshable = entity['refreshable'] == true &&
              entity['conversionType'] == ConversionType.formula;
          if (valuesAreRefreshable) {
            _insertRefreshableValuesUnits(txn, unitIds);
          }
        },
      );
    }
  }

  Future<int> _insertGroup(
    Transaction txn,
    Map<String, dynamic> entity,
  ) async {
    int groupId = await txn.insert(unitGroupsTableName, {
      'name': entity['groupName'],
      'icon_name': entity['iconName'],
      'conversion_type': entity['conversionType'],
      'refreshable': entity['refreshable'] == true ? 1 : null,
    });

    return groupId;
  }

  Future<List<int>> _insertUnits(
    Transaction txn,
    int unitGroupId,
    Map<String, dynamic> entity,
  ) async {
    Batch batch = txn.batch();

    for (Map<String, dynamic> unit in entity['units']) {
      batch.insert(
        unitsTableName,
        {
          'name': unit['name'],
          'abbreviation': unit['abbreviation'],
          'coefficient': unit['coefficient'],
          'unit_group_id': unitGroupId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    List<Object?> result = await batch.commit(continueOnError: true);
    return result.map((item) => item as int).toList();
  }

  Future<void> _insertRefreshableValuesUnits(
    Transaction txn,
    List<int> unitIds,
  ) async {
    Batch batch = txn.batch();

    for (int unitId in unitIds) {
      batch.insert(
        refreshableValuesTableName,
        {
          'unit_id': unitId,
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true, continueOnError: true);
  }
}

final initialization = Callback(
  onCreate: (database, version) {
    log("[onCreate] Current database version: $version");
    for (int version = 1; version <= dbVersion; version++) {
      log("[onCreate] Initialization units of version $version");
      ConvertouchDatabaseHelper.I.fillDatabase(
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
