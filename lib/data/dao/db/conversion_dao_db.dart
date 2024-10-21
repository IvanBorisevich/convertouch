import 'package:convertouch/data/dao/conversion_dao.dart';
import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ConversionDaoDb extends ConversionDao {
  @override
  @Query('SELECT c.* '
      'FROM $conversionsTableName c '
      'INNER JOIN ('
      ' SELECT id, MAX(last_modified) as latest_modified'
      ' FROM $conversionsTableName'
      ' WHERE unit_group_id = :unitGroupId'
      ' GROUP BY id'
      ' LIMIT 1'
      ') mc ON c.id = mc.id AND c.last_modified = mc.latest_modified')
  Future<ConversionEntity?> getLast(int unitGroupId);

  @override
  @Insert(onConflict: OnConflictStrategy.fail)
  Future<int> insert(ConversionEntity conversion);

  @override
  @Update()
  Future<int> update(ConversionEntity conversion);

  @override
  @Query("delete from $conversionsTableName where id in (:unitGroupIds)")
  Future<void> removeByGroupIds(List<int> unitGroupIds);
}
