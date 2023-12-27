import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:sqflite/sqflite.dart';

abstract class RefreshableValueDao {
  const RefreshableValueDao();

  Future<List<RefreshableValueEntity>> getList(List<int> unitIds);

  Future<void> bulkInsert(
    DatabaseExecutor db,
    List<RefreshableValueEntity> entities,
  );

  Future<void> bulkUpdate(
    DatabaseExecutor db,
    List<RefreshableValueEntity> entities,
  );
}
