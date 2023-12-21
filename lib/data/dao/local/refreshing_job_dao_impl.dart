import 'package:convertouch/data/dao/refreshing_job_dao.dart';
import 'package:convertouch/data/entities/refreshing_job_entity.dart';
import 'package:convertouch/domain/constants/default_refreshing_jobs.dart';

class RefreshingJobDaoImpl extends RefreshingJobDao {
  const RefreshingJobDaoImpl();

  @override
  Future<List<RefreshingJobEntity>> getAll() {
    return Future.sync(() => refreshingJobs
        .map((item) => RefreshingJobEntity.fromJson(item))
        .toList());
  }
}
