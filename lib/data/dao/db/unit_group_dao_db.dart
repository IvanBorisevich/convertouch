import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class UnitGroupDaoDb extends UnitGroupDao {
  @override
  @Query('select * from $unitGroupsTableName')
  Future<List<UnitGroupEntity>> getAll();

  @override
  @Query('select * from $unitGroupsTableName where id = :id limit 1')
  Future<UnitGroupEntity?> get(int id);

  @override
  @Insert(onConflict: OnConflictStrategy.fail)
  Future<int> insert(UnitGroupEntity unitGroupEntity);

  @override
  @Update()
  Future<int> update(UnitGroupEntity unitGroupEntity);

  @override
  Future<int> merge(UnitGroupEntity unitGroupEntity) {
    return Future.sync(
      () => insert(unitGroupEntity),
    ).onError(
      (error, stackTrace) => update(unitGroupEntity),
    );
  }
}