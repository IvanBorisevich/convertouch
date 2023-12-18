import 'package:convertouch/data/entities/unit_entity.dart';

abstract class UnitDao {
  const UnitDao();

  Future<List<UnitEntity>> getAll(int unitGroupId);

  Future<List<UnitEntity>> getBySearchString(int unitGroupId, String searchString);

  Future<UnitEntity?> getByName(int unitGroupId, String name);

  Future<UnitEntity?> getFirstUnit(int unitGroupId);

  Future<UnitEntity?> getUnit(int id);

  Future<List<UnitEntity>> getUnits(List<int> ids);

  Future<int> insert(UnitEntity unit);

  Future<int> update(UnitEntity unit);

  Future<int> merge(UnitEntity unit);

  Future<void> remove(List<int> ids);
}