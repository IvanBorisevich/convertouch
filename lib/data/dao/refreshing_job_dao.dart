import 'package:convertouch/data/entities/refreshing_job_entity.dart';

abstract class RefreshingJobDao {
  const RefreshingJobDao();

  Future<List<RefreshingJobEntity>> getAll();

  Future<RefreshingJobEntity?> get(int id);

  Future<RefreshingJobEntity?> getByGroupId(int unitGroupId);

  Future<void> update(RefreshingJobEntity entity);
}