import 'package:convertouch/data/entities/unit_group_entity.dart';

abstract class UnitGroupDao {
  const UnitGroupDao();

  Future<List<UnitGroupEntity>> fetchUnitGroups();

  Future<int> addUnitGroup(UnitGroupEntity unitGroupEntity);

  Future<UnitGroupEntity?> getUnitGroup(int id);
}