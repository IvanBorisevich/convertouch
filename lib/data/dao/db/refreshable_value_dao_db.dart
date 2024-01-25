import 'package:convertouch/data/dao/refreshable_value_dao.dart';
import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

@dao
abstract class RefreshableValueDaoDb extends RefreshableValueDao {
  @override
  @Query('select * from $refreshableValuesTableName '
      'where unit_id = :unitId '
      'limit 1')
  Future<RefreshableValueEntity?> get(int unitId);

  @override
  @Query('select * from $refreshableValuesTableName '
      'where unit_id in (:unitIds)')
  Future<List<RefreshableValueEntity>> getList(List<int> unitIds);

  @override
  Future<void> insertBatch(
    sqlite.Database db,
    List<RefreshableValueEntity> entities,
  ) async {
    var batch = db.batch();
    for (RefreshableValueEntity entity in entities) {
      db.insert(
        refreshableValuesTableName,
        entity.toJson(),
        conflictAlgorithm: sqlite.ConflictAlgorithm.ignore,
      );
    }
    batch.commit(noResult: true);
  }

  @override
  Future<void> updateBatch(
    sqlite.Database db,
    List<RefreshableValueEntity> entities,
  ) async {
    var batch = db.batch();
    for (RefreshableValueEntity entity in entities) {
      db.update(
        refreshableValuesTableName,
        entity.toJson(),
        conflictAlgorithm: sqlite.ConflictAlgorithm.ignore,
      );
    }
    batch.commit(noResult: true);
  }
}
