import 'package:convertouch/data/dao/refreshable_value_dao.dart';
import 'package:convertouch/data/entities/refreshable_value_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class RefreshableValueDaoDb extends RefreshableValueDao {
  @override
  Future<List<RefreshableValueEntity>> getList(List<int> unitIds) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future<int> insert(RefreshableValueEntity entity) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<int> merge(RefreshableValueEntity entity) {
    // TODO: implement merge
    throw UnimplementedError();
  }

  @override
  Future<int> update(RefreshableValueEntity entity) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<List<int>> bulkMerge(List<RefreshableValueEntity> entity) {
    // TODO: implement bulkMerge
    throw UnimplementedError();
  }
}