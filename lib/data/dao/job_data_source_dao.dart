import 'package:convertouch/data/entities/job_data_source_entity.dart';

abstract class JobDataSourceDao {
  const JobDataSourceDao();

  Future<JobDataSourceEntity?> get(int id);

  Future<List<JobDataSourceEntity>> getByIds(List<int> ids);

  Future<List<JobDataSourceEntity>> getByJobId(int jobId);
}