import 'package:convertouch/data/entities/unit_group_entity.dart';

abstract class UnitGroupDao {
  const UnitGroupDao();

  Future<List<UnitGroupEntity>> getAll();

  Future<UnitGroupEntity?> get(int id);

  Future<int> insert(UnitGroupEntity unitGroupEntity);

  Future<int> update(UnitGroupEntity unitGroupEntity);
}