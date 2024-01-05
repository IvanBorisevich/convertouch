import 'package:convertouch/data/dao/cron_dao.dart';
import 'package:convertouch/data/entities/cron_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class CronDaoDb extends CronDao {
  @override
  @Query('select * from $cronTableName')
  Future<List<CronEntity>> getAll();

  @override
  @Query('select * from $cronTableName where id = :id')
  Future<CronEntity?> get(int id);
}