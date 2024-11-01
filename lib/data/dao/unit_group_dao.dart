import 'package:convertouch/data/entities/unit_group_entity.dart';

abstract class UnitGroupDao {
  const UnitGroupDao();

  Future<List<UnitGroupEntity>> getAll({
    required int pageSize,
    required int offset,
  });

  Future<List<UnitGroupEntity>> getBySearchString({
    required String searchString,
    required int pageSize,
    required int offset,
  });

  Future<List<UnitGroupEntity>> getRefreshableGroups();

  Future<UnitGroupEntity?> get(int id);

  Future<UnitGroupEntity?> getByName(String name);

  Future<int> insert(UnitGroupEntity unitGroupEntity);

  Future<int> update(UnitGroupEntity unitGroupEntity);

  Future<void> remove(List<int> ids);
}
