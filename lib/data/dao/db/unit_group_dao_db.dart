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
}

// final List<UnitGroupEntity> _allUnitGroups = [
//   UnitGroupEntity(id: 1, name: 'Length'),
//   UnitGroupEntity(id: 2, name: 'Area'),
//   UnitGroupEntity(id: 3, name: 'Mass'),
//   UnitGroupEntity(id: 4, name: 'Speed'),
//   UnitGroupEntity(id: 5, name: 'Volume'),
//   UnitGroupEntity(id: 6, name: 'Currency'),
//   UnitGroupEntity(id: 7, name: 'Temperature'),
//   UnitGroupEntity(id: 8, name: 'Numeral System'),
// ];
