import 'package:convertouch/data/dao/job_data_source_dao.dart';
import 'package:convertouch/data/entities/job_data_source_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class JobDataSourceDaoDb extends JobDataSourceDao {
  @override
  @Query('select * from $jobDataSourcesTableName where id = :id')
  Future<JobDataSourceEntity?> get(int id);

  @override
  @Query('select * from $jobDataSourcesTableName where id in (:ids)')
  Future<List<JobDataSourceEntity>> getByIds(List<int> ids);

  @override
  @Query('select * from $jobDataSourcesTableName where job_id = :jobId')
  Future<List<JobDataSourceEntity>> getByJobId(int jobId);
}