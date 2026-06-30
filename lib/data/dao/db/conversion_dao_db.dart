import 'package:convertouch/data/dao/conversion_dao.dart';
import 'package:convertouch/data/entities/conversion_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ConversionDaoDb extends ConversionDao {
  @override
  @Query('SELECT c1.* '
      'FROM $conversionsTableName c1 '
      'LEFT JOIN ('
      ' SELECT unit_group_id, MAX(last_modified) as latest_modified'
      ' FROM $conversionsTableName'
      ' WHERE unit_group_id = :unitGroupId'
      ' GROUP BY unit_group_id'
      ') c2 '
      'ON c1.unit_group_id = c2.unit_group_id '
      'AND c1.last_modified = c2.latest_modified '
      'WHERE c2.latest_modified IS NOT NULL')
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
