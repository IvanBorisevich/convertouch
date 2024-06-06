import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/utils/sql_utils.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:sqflite/sqflite.dart';

abstract class ConvertouchDbMigration {
  const ConvertouchDbMigration();

  Future<void> execute(Database database);

  static Future<void> fillUnits(
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
      String? query = SqlUtils.getUpdateQuery(
        tableName: unitGroupsTableName,
        id: groupId,
        row: UnitGroupEntity.entityToRow(
          entity,
          autoSetDefaults: false,
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
      String? query = SqlUtils.getUpdateQuery(
        tableName: unitsTableName,
        id: unitId,
        row: UnitEntity.entityToRow(
          entity,
          unitGroupId: unitGroupId,
          autoSetDefaults: false,
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
