import 'package:convertouch/data/entities/unit_entity.dart';

abstract class UnitDao {
  const UnitDao();

  Future<List<UnitEntity>> getAll(int unitGroupId);

  Future<UnitEntity?> getByName(int unitGroupId, String name);

  Future<UnitEntity?> getFirstUnit(int unitGroupId);

  Future<int> insert(UnitEntity unit);

  Future<int> update(UnitEntity unit);

  Future<int> merge(UnitEntity unit);

  Future<void> remove(List<int> ids);
}