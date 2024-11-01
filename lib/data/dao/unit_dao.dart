import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

abstract class UnitDao {
  const UnitDao();

  Future<List<UnitEntity>> getAll({
    required int unitGroupId,
    required int pageSize,
    required int offset,
  });

  Future<List<UnitEntity>> getBySearchString({
    required String searchString,
    required int unitGroupId,
    required int pageSize,
    required int offset,
  });

  Future<UnitEntity?> getByCode(int unitGroupId, String code);

  Future<List<UnitEntity>> getBaseUnits(int unitGroupId);

  Future<UnitEntity?> getUnit(int id);

  Future<List<UnitEntity>> getUnitsByIds(List<int> ids);

  Future<List<UnitEntity>> getUnitsByCodes(
    String unitGroupName,
    List<String> codes,
  );

  Future<List<UnitEntity>> updateUnitsCoefficients(
    sqlite.Database db,
    String unitGroupName,
    Map<String, double?> codeToCoefficient,
  );

  Future<int> insert(UnitEntity unit);

  Future<void> updateBatch(sqlite.Database db, List<UnitEntity> units);

  Future<int> update(UnitEntity unit);

  Future<void> remove(List<int> ids);
}
