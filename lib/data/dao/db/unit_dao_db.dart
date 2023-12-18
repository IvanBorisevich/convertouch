import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class UnitDaoDb extends UnitDao {
  @override
  @Query('select * from $unitsTableName where unit_group_id = :unitGroupId')
  Future<List<UnitEntity>> getAll(int unitGroupId);

  @override
  @Query('select * from $unitsTableName where unit_group_id = :unitGroupId '
      'and name like :searchString')
  Future<List<UnitEntity>> getBySearchString(
    int unitGroupId,
    String searchString,
  );

  @override
  @Query('select * from $unitsTableName '
      'where unit_group_id = :unitGroupId '
      'and name = :name')
  Future<UnitEntity?> getByName(int unitGroupId, String name);

  @override
  @Query('select * from $unitsTableName '
      'where unit_group_id = :unitGroupId '
      'limit 1')
  Future<UnitEntity?> getFirstUnit(int unitGroupId);

  @override
  @Query('select * from $unitsTableName where id = :id limit 1')
  Future<UnitEntity?> getUnit(int id);

  @override
  @Query('select * from $unitsTableName where id in (:ids)')
  Future<List<UnitEntity>> getUnits(List<int> ids);

  @override
  @Insert(onConflict: OnConflictStrategy.fail)
  Future<int> insert(UnitEntity unit);

  @override
  @Update()
  Future<int> update(UnitEntity unit);

  @override
  Future<int> merge(UnitEntity unit) {
    return Future.sync(
      () => insert(unit),
    ).onError(
      (error, stackTrace) => update(unit),
    );
  }

  @override
  @Query("delete from $unitsTableName where id in (:ids)")
  Future<void> remove(List<int> ids);
}
