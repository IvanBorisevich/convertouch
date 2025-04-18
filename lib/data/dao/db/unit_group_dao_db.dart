import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class UnitGroupDaoDb extends UnitGroupDao {
  @override
  @Query('select * from $unitGroupsTableName '
      'where name like :searchString '
      'order by name '
      'limit :pageSize offset :offset'
  )
  Future<List<UnitGroupEntity>> getBySearchString({
    required String searchString,
    required int pageSize,
    required int offset,
  });

  @override
  @Query('select * from $unitGroupsTableName where refreshable is not null')
  Future<List<UnitGroupEntity>> getRefreshableGroups();

  @override
  @Query('select * from $unitGroupsTableName where id = :id limit 1')
  Future<UnitGroupEntity?> get(int id);

  @override
  @Query('select * from $unitGroupsTableName where name = :name limit 1')
  Future<UnitGroupEntity?> getByName(String name);

  @override
  @Insert(onConflict: OnConflictStrategy.fail)
  Future<int> insert(UnitGroupEntity unitGroupEntity);

  @override
  @Update()
  Future<int> update(UnitGroupEntity unitGroupEntity);

  @override
  @Query("delete from $unitGroupsTableName where id in (:ids)")
  Future<void> remove(List<int> ids);
}