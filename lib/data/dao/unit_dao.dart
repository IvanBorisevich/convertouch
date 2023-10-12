import 'package:convertouch/data/entities/unit_entity.dart';

abstract class UnitDao {
  const UnitDao();

  Future<List<UnitEntity>> getAll(int unitGroupId);

  Future<UnitEntity?> getBaseUnit(int unitGroupId);

  Future<UnitEntity?> getFirst(int unitGroupId);

  Future<int> insert(UnitEntity unit);

  Future<int> update(UnitEntity unit);

  Future<int> merge(UnitEntity unit);
}