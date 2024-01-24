import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

abstract class RefreshableValueDao {
  const RefreshableValueDao();

  Future<RefreshableValueEntity?> get(int unitId);

  Future<List<RefreshableValueEntity>> getList(List<int> unitIds);

  Future<void> insertBatch(
    sqlite.Database db,
    List<RefreshableValueEntity> entities,
  );

  Future<void> updateBatch(
    sqlite.Database db,
    List<RefreshableValueEntity> entities,
  );
}
