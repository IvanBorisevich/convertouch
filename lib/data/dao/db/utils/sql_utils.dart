import 'package:collection/collection.dart';
import 'package:convertouch/data/entities/conversion_param_entity.dart';
import 'package:convertouch/data/entities/conversion_param_set_entity.dart';
import 'package:convertouch/data/entities/conversion_param_unit_entity.dart';
import 'package:convertouch/data/entities/dynamic_value_entity.dart';
import 'package:convertouch/data/entities/entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:sqflite/sqflite.dart';

class QueryWithParams {
  static const noQuery = QueryWithParams(sqlQuery: null);

  final String? sqlQuery;
  final List<Object?> params;

  const QueryWithParams({
    required this.sqlQuery,
    this.params = const [],
  });
}

final argPattern = RegExp(r'\?');

const getGroups = "SELECT id, name FROM unit_groups";
const getUnitCodesByGroupId =
    "SELECT id, code FROM units WHERE unit_group_id = ?";
const getUnitIdsByCodesAndGroupName = "SELECT u.id "
    "FROM units u "
    "INNER JOIN unit_groups g ON g.id = u.unit_group_id "
    "WHERE g.name = ? "
    "AND u.code in (?)";
const getUnitIdByCodeAndGroupName = "SELECT u.id "
    "FROM units u "
    "INNER JOIN unit_groups g ON g.id = u.unit_group_id "
    "WHERE g.name = ? "
    "AND u.code = ? "
    "LIMIT 1";
const getExistingParamSets = "SELECT id, name FROM conversion_param_sets";
const getExistingParamsBySetId = "SELECT id, name FROM conversion_params "
    "WHERE param_set_id = ?";
const getExistingParamsByIds = "SELECT id, name FROM conversion_params "
    "WHERE id in (?)";
const getGroupIdByName = "SELECT id FROM unit_groups WHERE name = ? limit 1";

typedef ChildItemsMergeFunc = Future<List<int>> Function(
  Transaction,
  Map<String, dynamic>,
  int,
);

typedef ChildItemsPostMergeFunc = Future<void> Function(
  Transaction,
  dynamic,
  List<int>,
);

typedef RowFunc = Future<Map<String, dynamic>> Function(
  Map<String, dynamic>,
  Transaction,
);

class SqlUtils {
  const SqlUtils._();

  static Future<void> mergeGroupsAndUnits(
    Database database, {
    required List<dynamic> items,
  }) async {
    await database.transaction((txn) async {
      await _mergeItems(
        txn: txn,
        items: items,
        existingItemsQuery: getGroups,
        tableName: unitGroupsTableName,
        uniqueColumnName: 'groupName',
        rowFunc: (item, txn) async => UnitGroupEntity.jsonToRow(
          item,
        ),
        childItemsMergeFunc: (txn, parentJson, parentId) async {
          return await _mergeItems(
            txn: txn,
            items: parentJson['units'],
            existingItemsQuery: getUnitCodesByGroupId,
            existingItemsQueryArgs: [parentId],
            existingItemNameFunc: (item) => item['code'],
            existingItemIdFunc: (item) => item['id'],
            tableName: unitsTableName,
            uniqueColumnName: 'code',
            rowFunc: (item, txn) async => UnitEntity.jsonToRow(
              item,
              unitGroupId: parentId,
            ),
          );
        },
        childItemsPostMergeFunc: (txn, parentJson, childItemIds) async {
          if (parentJson['refreshable'] == true) {
            Batch batch = txn.batch();

            for (int unitId in childItemIds) {
              batch.insert(
                dynamicValuesTableName,
                {'unit_id': unitId},
                conflictAlgorithm: ConflictAlgorithm.ignore,
              );
            }

            await batch.commit(noResult: true, continueOnError: false);
          }
        },
      );
    });
  }

  static Future<void> mergeConversionParams(
    Database database, {
    required List<dynamic> items,
  }) async {
    await database.transaction((txn) async {
      await _mergeItems(
        txn: txn,
        items: items,
        existingItemsQuery: getExistingParamSets,
        tableName: conversionParamSetsTableName,
        rowFunc: (item, txn) async => ConversionParamSetEntity.jsonToRow(
          item,
          unitGroupId: await selectFirst(
            txn: txn,
            query: getGroupIdByName,
            args: [item["unitGroupName"]],
          ),
        ),
        childItemsMergeFunc: (txn, parentJson, parentId) async {
          return await _mergeItems(
            txn: txn,
            items: parentJson['params'],
            existingItemsQuery: getExistingParamsBySetId,
            existingItemsQueryArgs: [parentId],
            tableName: conversionParamsTableName,
            rowFunc: (item, txn) async => ConversionParamEntity.jsonToRow(
              item,
              paramSetId: parentId,
              paramUnitGroupId: item["unitGroupName"] != null
                  ? await selectFirst(
                      txn: txn,
                      query: getGroupIdByName,
                      args: [item["unitGroupName"]],
                    )
                  : null,
              defaultUnitId: item["defaultUnitCode"] != null
                  ? await selectFirst(
                      txn: txn,
                      query: getUnitIdByCodeAndGroupName,
                      args: [
                        item["unitGroupName"],
                        item["defaultUnitCode"],
                      ],
                    )
                  : null,
            ),
          );
        },
        childItemsPostMergeFunc: (txn, parentJson, childItemIds) async {
          await _mergeParamPossibleUnits(
            txn: txn,
            mergedParamIds: childItemIds,
            paramJsonItems: parentJson['params'],
          );
        },
      );
    });
  }

  static Future<List<int>> _mergeItems({
    required Transaction txn,
    List<dynamic>? items,
    required String existingItemsQuery,
    List<Object> existingItemsQueryArgs = const [],
    String Function(Map<String, dynamic>)? existingItemNameFunc,
    int Function(Map<String, dynamic>)? existingItemIdFunc,
    required String tableName,
    String uniqueColumnName = 'name',
    required RowFunc rowFunc,
    ChildItemsMergeFunc? childItemsMergeFunc,
    bool childrenBatchMerge = true,
    ChildItemsPostMergeFunc? childItemsPostMergeFunc,
  }) async {
    if (items == null || items.isEmpty) {
      return [];
    }

    Map<String, int> existingItems = await selectPairs(
      txn: txn,
      query: existingItemsQuery,
      args: existingItemsQueryArgs,
      kFunc: existingItemNameFunc,
      vFunc: existingItemIdFunc,
    );

    List<int> itemIds = [];
    Batch? batch;

    for (Map<String, dynamic> json in items) {
      int? existingItemId = existingItems[json[uniqueColumnName]];

      if (existingItemId == null &&
          json[forUpdate] != null &&
          (json[forUpdate] as Map).isNotEmpty) {
        continue;
      }

      var row = await rowFunc.call(json, txn);

      if (childrenBatchMerge) {
        batch ??= txn.batch();

        int itemId = _mergeItemBatch(
          batch: batch,
          tableName: tableName,
          itemId: existingItemId,
          row: row,
        );

        itemIds.add(itemId);
      } else {
        int itemId = await _mergeItem(
          txn: txn,
          tableName: tableName,
          itemId: existingItemId,
          row: row,
        );

        itemIds.add(itemId);

        List<int> childItemIds =
            await childItemsMergeFunc?.call(txn, json, itemId) ?? [];
        await childItemsPostMergeFunc?.call(txn, json, childItemIds);
      }
    }

    if (childrenBatchMerge && batch != null) {
      List<Object?> result = await batch.commit(continueOnError: false);

      for (int i = 0; i < items.length; i++) {
        if (itemIds[i] == -1) {
          itemIds[i] = result[i] as int;
        }

        var json = items[i];

        List<int> childItemIds =
            await childItemsMergeFunc?.call(txn, json, itemIds[i]) ?? [];
        await childItemsPostMergeFunc?.call(txn, json, childItemIds);
      }
    }

    return itemIds;
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

  static Future<void> _mergeParamPossibleUnits({
    required Transaction txn,
    required List<int> mergedParamIds,
    required List<Map<String, dynamic>> paramJsonItems,
  }) async {
    Map<String, int> paramsWithUnits = await selectPairs(
      txn: txn,
      query: getExistingParamsByIds,
      args: [mergedParamIds],
    );

    Batch batch = txn.batch();

    for (var json in paramJsonItems) {
      int paramId = paramsWithUnits[json['name']]!;
      String? paramGroupName = json['unitGroupName'];
      List<String>? possibleUnitCodes = json['possibleUnitCodes'];

      if (paramGroupName == null ||
          possibleUnitCodes == null ||
          possibleUnitCodes.isEmpty) {
        continue;
      }

      List<int> newUnitIds = await selectSingles(
        txn: txn,
        query: getUnitIdsByCodesAndGroupName,
        args: [paramGroupName, possibleUnitCodes],
      );

      batch.rawDelete(
        "DELETE FROM $conversionParamUnitsTableName WHERE param_id = ?",
        [paramId],
      );

      for (int unitId in newUnitIds) {
        batch.insert(
          conversionParamUnitsTableName,
          {
            "param_id": paramId,
            "unit_id": unitId,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }

    await batch.commit(continueOnError: false, noResult: true);
  }

  static Future<int> _mergeItem({
    required Transaction txn,
    required String tableName,
    required int? itemId,
    required Map<String, dynamic> row,
  }) async {
    if (itemId != null) {
      var queryForUpdate = buildQueryForUpdate(
        tableName: tableName,
        id: itemId,
        row: row,
      );

      if (queryForUpdate.sqlQuery == null) {
        return itemId;
      }

      await txn.rawUpdate(queryForUpdate.sqlQuery!, queryForUpdate.params);

      return itemId;
    } else {
      return await txn.insert(
        tableName,
        row,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    }
  }

  static int _mergeItemBatch({
    required Batch batch,
    required String tableName,
    required int? itemId,
    required Map<String, dynamic> row,
  }) {
    if (itemId != null) {
      var queryForUpdate = buildQueryForUpdate(
        tableName: tableName,
        id: itemId,
        row: row,
      );

      if (queryForUpdate.sqlQuery != null) {
        batch.rawUpdate(queryForUpdate.sqlQuery!, queryForUpdate.params);
      }

      return itemId;
    } else {
      batch.insert(
        tableName,
        row,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );

      return -1;
    }
  }

  static QueryWithParams buildQueryForUpdate({
    required String tableName,
    required int id,
    required Map<String, dynamic> row,
  }) {
    List<MapEntry<String, dynamic>> rowEntries = row.entries.toList();

    if (rowEntries.isEmpty) {
      return QueryWithParams.noQuery;
    }

    List<String> setClauses = rowEntries.map((e) => '${e.key} = ?').toList();
    List<Object?> newColumnValues = rowEntries.map((e) => e.value).toList();

    String sqlQuery = 'UPDATE $tableName SET '
        '${setClauses.join(', ')}'
        ' WHERE id = $id';

    return QueryWithParams(sqlQuery: sqlQuery, params: newColumnValues);
  }

  static Future<V> selectFirst<V>({
    required Transaction txn,
    required String query,
    List<Object> args = const [],
    V Function(Map<String, dynamic>)? valFunc,
  }) async {
    List<Map<String, dynamic>> result = await txn.rawQuery(
      toInArgsQuery(query, args),
      flatten(args),
    );
    return valFunc?.call(result.first) ?? result.first["id"];
  }

  static Future<List<V>> selectSingles<V>({
    required Transaction txn,
    required String query,
    List<Object> args = const [],
    V Function(Map<String, dynamic>)? valFunc,
  }) async {
    List<Map<String, dynamic>> result = await txn.rawQuery(
      toInArgsQuery(query, args),
      flatten(args),
    );
    return result
        .map((item) => valFunc?.call(item) ?? item['id'] as V)
        .toList();
  }

  static Future<Map<K, V>> selectPairs<K, V>({
    required Transaction txn,
    required String query,
    List<Object> args = const [],
    K Function(Map<String, dynamic>)? kFunc,
    V Function(Map<String, dynamic>)? vFunc,
  }) async {
    List<Map<String, dynamic>> result = await txn.rawQuery(
      toInArgsQuery(query, args),
      flatten(args),
    );
    return {
      for (var item in result)
        kFunc?.call(item) ?? item["name"]: vFunc?.call(item) ?? item["id"]
    };
  }

  static String toInArgsQuery(String query, List<Object> args) {
    List<int> paramIndexes =
        argPattern.allMatches(query).map((match) => match.start).toList();

    String result = query;

    for (int i = 0; i < paramIndexes.length; i++) {
      var arg = args[i];

      if (arg is Iterable) {
        String inArgsPattern = List.filled(arg.length, '?').join(',');
        result =
            result.replaceFirst(argPattern, inArgsPattern, paramIndexes[i]);
      }
    }

    return result;
  }

  static List<T> flatten<T>(Iterable<dynamic> list) => [
        for (var element in list)
          if (element is! Iterable) element else ...flatten(element),
      ];
}
