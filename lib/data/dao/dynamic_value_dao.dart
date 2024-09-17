import 'package:convertouch/data/entities/dynamic_value_entity.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

abstract class DynamicValueDao {
  const DynamicValueDao();

  Future<DynamicValueEntity?> get(int unitId);

  Future<List<DynamicValueEntity>> getList(List<int> unitIds);

  Future<void> insertBatch(
    sqlite.Database db,
    List<DynamicValueEntity> entities,
  );

  Future<void> updateBatch(
    sqlite.Database db,
    List<DynamicValueEntity> entities,
  );
}
