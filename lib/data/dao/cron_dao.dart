import 'package:convertouch/data/entities/cron_entity.dart';

abstract class CronDao {
  const CronDao();

  Future<List<CronEntity>> getAll();

  Future<CronEntity?> get(int id);
}