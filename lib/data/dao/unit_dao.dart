import 'package:convertouch/data/entities/unit_entity.dart';

abstract class UnitDao {
  const UnitDao();

  Future<List<UnitEntity>> fetchUnitsOfGroup(int unitGroupId);

  Future<UnitEntity> getBaseUnit(int unitGroupId);

  Future<int> addUnit(UnitEntity unit);
}