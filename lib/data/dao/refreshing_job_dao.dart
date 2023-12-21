import 'package:convertouch/data/entities/refreshing_job_entity.dart';

abstract class RefreshingJobDao {
  const RefreshingJobDao();

  Future<List<RefreshingJobEntity>> getAll();
}