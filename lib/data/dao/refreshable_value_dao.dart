import 'package:convertouch/data/entities/refreshable_value_entity.dart';

abstract class RefreshableValueDao {
  Future<List<RefreshableValueEntity>> getList(List<int> unitIds);

  Future<int> insert(RefreshableValueEntity entity);

  Future<int> update(RefreshableValueEntity entity);

  Future<int> merge(RefreshableValueEntity entity);

  Future<List<int>> bulkMerge(List<RefreshableValueEntity> entity);
}