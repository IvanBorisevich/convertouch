import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class UnitDaoDb extends UnitDao {
  @override
  @Query('select * from $unitsTableName where unit_group_id = :unitGroupId')
  Future<List<UnitEntity>> getAll(int unitGroupId);

  @override
  @Query('select * from $unitsTableName '
      'where unit_group_id = :unitGroupId '
      'and coefficient = 1')
  Future<UnitEntity?> getBaseUnit(int unitGroupId);

  @override
  @Query('select * from $unitsTableName '
      'where unit_group_id = :unitGroupId limit 1')
  Future<UnitEntity?> getFirst(int unitGroupId);

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
