import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

abstract class UnitDao {
  const UnitDao();

  Future<List<UnitEntity>> getAll(int unitGroupId);

  Future<List<UnitEntity>> getBySearchString(
      int unitGroupId, String searchString);

  Future<UnitEntity?> getByCode(int unitGroupId, String code);

  Future<UnitEntity?> getBaseUnit(int unitGroupId);

  Future<UnitEntity?> getUnit(int id);

  Future<List<UnitEntity>> getUnitsByIds(List<int> ids);

  Future<List<UnitEntity>> getUnitsByCodes(int unitGroupId, List<String> codes);

  Future<List<UnitEntity>> updateUnitsCoefficients(
    sqlite.Database db,
    int unitGroupId,
    Map<String, double?> codeToCoefficient,
  );

  Future<int> insert(UnitEntity unit);

  Future<void> updateBatch(sqlite.Database db, List<UnitEntity> units);

  Future<int> update(UnitEntity unit);

  Future<int> merge(UnitEntity unit);

  Future<void> remove(List<int> ids);
}
