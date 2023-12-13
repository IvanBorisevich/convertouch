import 'package:convertouch/data/entities/unit_group_entity.dart';

abstract class UnitGroupDao {
  const UnitGroupDao();

  Future<List<UnitGroupEntity>> getAll();

  Future<List<UnitGroupEntity>> getBySearchString(String searchString);

  Future<UnitGroupEntity?> get(int id);

  Future<UnitGroupEntity?> getByName(String name);

  Future<int> insert(UnitGroupEntity unitGroupEntity);

  Future<int> update(UnitGroupEntity unitGroupEntity);

  Future<int> merge(UnitGroupEntity unitGroupEntity);

  Future<void> remove(List<int> ids);
}