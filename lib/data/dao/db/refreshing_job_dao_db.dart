import 'package:convertouch/data/dao/refreshing_job_dao.dart';
import 'package:convertouch/data/entities/refreshing_job_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class RefreshingJobDaoDb extends RefreshingJobDao {

  @override
  @Query('select * from $refreshingJobsTableName')
  Future<List<RefreshingJobEntity>> getAll();

  @override
  @Query('select * from $refreshingJobsTableName where id = :id')
  Future<RefreshingJobEntity?> get(int id);

  @override
  @Update(onConflict: OnConflictStrategy.fail)
  Future<void> update(RefreshingJobEntity entity);
}
