import 'package:collection/collection.dart';
import 'package:convertouch/data/entities/dynamic_value_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

class QueryParams {
  static const noQuery = QueryParams(sqlQuery: null);

  final String? sqlQuery;
  final List<Object?> params;

  const QueryParams({
    required this.sqlQuery,
    this.params = const [],
  });
}

class SqlUtils {
  const SqlUtils._();

  static QueryParams prepareUpdate({
    required String tableName,
    required int id,
    required Map<String, Object?> row,
    List<String> excludedColumns = const [],
  }) {
    List<MapEntry<String, Object?>> rowEntries = row.entries
        .whereNot((element) => excludedColumns.contains(element.key))
        .toList();

    if (rowEntries.isEmpty) {
      return QueryParams.noQuery;
    }

    List<String> columnNamesToUpdate = rowEntries.map((e) => e.key).toList();
    List<Object?> newColumnValues = rowEntries.map((e) => e.value).toList();

    String? sqlQuery = buildUpdateQuery(
      tableName: tableName,
      id: id,
      columnNamesToUpdate: columnNamesToUpdate,
    );

    if (sqlQuery == null) {
      return QueryParams.noQuery;
    }

    return QueryParams(sqlQuery: sqlQuery, params: newColumnValues);
  }

  static Future<int> update({
    required DatabaseExecutor executor,
    required QueryParams queryParams,
  }) async {
    if (queryParams.sqlQuery == null) {
      return 0;
    }
    return await executor.rawUpdate(queryParams.sqlQuery!, queryParams.params);
  }

  static void addToBatchUpdate({
    required Batch batch,
    required QueryParams queryParams,
  }) {
    if (queryParams.sqlQuery == null) {
      return;
    }
    batch.rawUpdate(queryParams.sqlQuery!, queryParams.params);
  }

  static String? buildUpdateQuery({
    required String tableName,
    required int id,
    required List<String> columnNamesToUpdate,
  }) {
    List<String> setClauses =
        columnNamesToUpdate.map((columnName) => '$columnName = ?').toList();

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

      await update(
        executor: database,
        queryParams: prepareUpdate(
          tableName: unitsTableName,
          id: unitId,
          row: {
            columnName: newColumnValue,
          },
        ),
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
      await database.transaction(
        (txn) async {
          int unitGroupId = await _mergeGroup(
            txn: txn,
            entity: entity,
            existingGroupNames: existingGroupNames,
          );

          Map<String, int> existingUnitCodes = await _getExistingUnitIdsCodes(
            txn: txn,
            unitGroupId: unitGroupId,
          );

          List<int> unitIds = await _mergeUnits(
            txn: txn,
            unitGroupId: unitGroupId,
            entity: entity,
            existingUnitCodes: existingUnitCodes,
          );

          bool valuesAreRefreshable = entity['refreshable'] == true &&
              entity['conversionType'] == ConversionType.formula;
          if (valuesAreRefreshable) {
            await _insertDynamicUnits(txn, unitIds);
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

  static Future<Map<String, int>> _getExistingUnitIdsCodes({
    required Transaction txn,
    required int unitGroupId,
  }) async {
    List<Map<String, dynamic>> result = await txn.rawQuery(
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

      Map<String, Object?> row = UnitGroupEntity.entityToRow(
        entity,
        initDefaults: false,
      );

      await update(
        executor: txn,
        queryParams: prepareUpdate(
          tableName: unitGroupsTableName,
          id: groupId,
          row: row,
          excludedColumns: ['name', 'oob'],
        ),
      );
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

      addToBatchUpdate(
        batch: batch,
        queryParams: prepareUpdate(
          tableName: unitsTableName,
          id: unitId,
          row: UnitEntity.entityToRow(
            entity,
            unitGroupId: unitGroupId,
            initDefaults: false,
          ),
          excludedColumns: ['code', 'oob', 'unit_group_id'],
        ),
      );
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

  static Future<void> _insertDynamicUnits(
    Transaction txn,
    List<int> unitIds,
  ) async {
    Batch batch = txn.batch();

    for (int unitId in unitIds) {
      batch.insert(
        dynamicValuesTableName,
        {
          'unit_id': unitId,
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true, continueOnError: false);
  }
}
