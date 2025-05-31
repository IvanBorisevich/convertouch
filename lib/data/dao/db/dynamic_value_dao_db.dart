import 'package:convertouch/data/dao/dynamic_value_dao.dart';
import 'package:convertouch/data/entities/dynamic_value_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

@dao
abstract class DynamicValueDaoDb extends DynamicValueDao {
  @override
  @Query('select * from $dynamicValuesTableName '
      'where unit_id = :unitId '
      'limit 1')
  Future<DynamicValueEntity?> get(int unitId);

  @override
  @Query('select * from $dynamicValuesTableName '
      'where unit_id in (:unitIds)')
  Future<List<DynamicValueEntity>> getList(List<int> unitIds);

  @override
  Future<void> insertBatch(
    sqlite.Database db,
    List<DynamicValueEntity> entities,
  ) async {
    var batch = db.batch();
    for (DynamicValueEntity entity in entities) {
      batch.insert(
        dynamicValuesTableName,
        entity.toRow(),
        conflictAlgorithm: sqlite.ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<void> updateBatch(
    sqlite.Database db,
    List<DynamicValueEntity> entities,
  ) async {
    var batch = db.batch();
    for (DynamicValueEntity entity in entities) {
      batch.update(
        dynamicValuesTableName,
        entity.toRow(),
        conflictAlgorithm: sqlite.ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }
}
