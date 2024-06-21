import 'package:collection/collection.dart';
import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class SqlUtils {
  const SqlUtils._();

  static String? buildUpdateQuery({
    required String tableName,
    required int id,
    required Map<String, Object?> row,
    List<String> excludedColumns = const [],
  }) {
    mappingFunc(MapEntry<String, Object?> e) {
      String name = e.key;
      Object? value;
      if (!excludedColumns.contains(e.key)) {
        value = e.value.runtimeType == String ? "'${e.value}'" : e.value;
        return '$name = $value';
      }
      return null;
    }

    List<String> setClauses = row.entries.map(mappingFunc).nonNulls.toList();
    return setClauses.isNotEmpty
        ? 'UPDATE $tableName SET '
            '${setClauses.join(', ')}'
            ' WHERE id = $id'
        : null;
  }

  static Future<bool> isColumnNew(
    Database database, {
    required String tableName,
    required String columnName,
  }) async {
    final tableInfo = await database.rawQuery('PRAGMA table_info($tableName)');
    return tableInfo.none(
      (rowMap) => rowMap["name"] == columnName,
    );
  }

  static Future<void> updateUnitColumn(
    Database database, {
    required String columnName,
    required Object? newColumnValue,
    required String unitCode,
    required String groupName,
  }) async {
    List<Map<String, dynamic>> result = await database.rawQuery(
      "SELECT u.id FROM unit_groups g, units u "
      "WHERE 1=1 "
      "AND u.code = ? "
      "AND g.name = ? "
      "AND u.unit_group_id = g.id ",
      [unitCode, groupName],
    );
    if (result.isNotEmpty) {
      int unitId = result.first['id'];

      await database.rawUpdate(
        buildUpdateQuery(
          tableName: unitsTableName,
          id: unitId,
          row: {
            columnName: newColumnValue,
          },
        )!,
      );
    }
  }

  static Future<void> mergeGroupsAndUnits(
    Database database, {
    required List<dynamic> entities,
  }) async {
    Map<String, int> existingGroupNames =
        await _getExistingGroupIdsNames(database);
    for (Map<String, dynamic> entity in entities) {
      database.transaction(
        (txn) async {
          int unitGroupId = await _mergeGroup(
            txn: txn,
            entity: entity,
            existingGroupNames: existingGroupNames,
          );

          Map<String, int> existingUnitCodes =
              await _getExistingUnitIdsCodes(database, unitGroupId);

          List<int> unitIds = await _mergeUnits(
            txn: txn,
            unitGroupId: unitGroupId,
            entity: entity,
            existingUnitCodes: existingUnitCodes,
          );

          bool valuesAreRefreshable = entity['refreshable'] == true &&
              entity['conversionType'] == ConversionType.formula;
          if (valuesAreRefreshable) {
            _insertRefreshableValuesUnits(txn, unitIds);
          }
        },
      );
    }
  }

  static Future<Map<String, int>> _getExistingGroupIdsNames(
    Database database,
  ) async {
    List<Map<String, dynamic>> result =
        await database.rawQuery("SELECT id, name FROM unit_groups");
    return {for (var item in result) item["name"]: item["id"]};
  }

  static Future<Map<String, int>> _getExistingUnitIdsCodes(
    Database database,
    int unitGroupId,
  ) async {
    List<Map<String, dynamic>> result = await database.rawQuery(
        "SELECT id, code FROM units WHERE unit_group_id = $unitGroupId");
    return {for (var item in result) item["code"]: item["id"]};
  }

  static Future<int> _mergeGroup({
    required Transaction txn,
    required Map<String, dynamic> entity,
    required Map<String, int> existingGroupNames,
  }) async {
    int groupId;
    if (existingGroupNames.containsKey(entity['groupName'])) {
      groupId = existingGroupNames[entity['groupName']]!;
      String? query = buildUpdateQuery(
        tableName: unitGroupsTableName,
        id: groupId,
        row: UnitGroupEntity.entityToRow(
          entity,
          initDefaults: false,
        ),
        excludedColumns: ['name', 'oob'],
      );
      if (query != null) {
        await txn.rawUpdate(query);
      }
    } else {
      groupId = await txn.insert(
        unitGroupsTableName,
        UnitGroupEntity.entityToRow(entity),
      );
    }

    return groupId;
  }

  static Future<List<int>> _mergeUnits({
    required Transaction txn,
    required int unitGroupId,
    required Map<String, dynamic> entity,
    required Map<String, int> existingUnitCodes,
  }) async {
    Batch batch = txn.batch();

    for (Map<String, dynamic> unit in entity['units']) {
      _mergeUnit(
        batch: batch,
        unitGroupId: unitGroupId,
        entity: unit,
        existingUnitCodes: existingUnitCodes,
      );
    }

    List<Object?> result = await batch.commit(continueOnError: false);
    return result.map((item) => item as int).toList();
  }

  static void _mergeUnit({
    required Batch batch,
    required int unitGroupId,
    required Map<String, dynamic> entity,
    required Map<String, int> existingUnitCodes,
  }) {
    if (existingUnitCodes.containsKey(entity['code'])) {
      int unitId = existingUnitCodes[entity['code']]!;
      String? query = buildUpdateQuery(
        tableName: unitsTableName,
        id: unitId,
        row: UnitEntity.entityToRow(
          entity,
          unitGroupId: unitGroupId,
          initDefaults: false,
        ),
        excludedColumns: ['code', 'oob', 'unit_group_id'],
      );
      if (query != null) {
        batch.rawUpdate(query);
      }
    } else {
      batch.insert(
        unitsTableName,
        UnitEntity.entityToRow(
          entity,
          unitGroupId: unitGroupId,
        ),
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
  }

  static Future<void> _insertRefreshableValuesUnits(
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

    await batch.commit(noResult: true, continueOnError: false);
  }
}
