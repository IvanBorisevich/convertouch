import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/conversion_param_entity.dart';
import 'package:convertouch/data/entities/conversion_param_unit_entity.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

@dao
abstract class UnitDaoDb extends UnitDao {

  @override
  @Query('select '
      'u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, '
      'u.invertible, u.oob, '
      'coalesce(u.value_type, g.value_type) value_type, '
      'coalesce(u.min_value, g.min_value) min_value, '
      'coalesce(u.max_value, g.max_value) max_value '
      'from $unitsTableName u '
      'inner join $unitGroupsTableName g on g.id = u.unit_group_id '
      'where g.id = :unitGroupId '
      'and (u.name like :searchString or u.code like :searchString) '
      'order by u.code '
      'limit :pageSize offset :offset')
  Future<List<UnitEntity>> searchWithGroupId({
    required String searchString,
    required int unitGroupId,
    required int pageSize,
    required int offset,
  });

  @override
  @Query('select '
      'u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, '
      'u.invertible, u.oob, '
      'coalesce(u.value_type, g.value_type) value_type, '
      'coalesce(u.min_value, g.min_value) min_value, '
      'coalesce(u.max_value, g.max_value) max_value '
      'from $unitsTableName u '
      'inner join $conversionParamUnitsTableName p on p.unit_id = u.id '
      'inner join $unitGroupsTableName g on g.id = u.unit_group_id '
      'where p.param_id = :paramId '
      'order by u.code '
      'limit :pageSize offset :offset')
  Future<List<UnitEntity>> getByParamId({
    required int paramId,
    required int pageSize,
    required int offset,
  });

  @override
  @Query('select '
      'u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, '
      'u.invertible, u.oob, '
      'coalesce(u.value_type, g.value_type) value_type, '
      'coalesce(u.min_value, g.min_value) min_value, '
      'coalesce(u.max_value, g.max_value) max_value '
      'from $unitsTableName u '
      'inner join $conversionParamUnitsTableName p on p.unit_id = u.id '
      'inner join $unitGroupsTableName g on g.id = u.unit_group_id '
      'where p.param_id = :paramId '
      'and (u.name like :searchString or u.code like :searchString) '
      'order by u.code '
      'limit :pageSize offset :offset')
  Future<List<UnitEntity>> searchWithParamIdAndPossibleUnits({
    required String searchString,
    required int paramId,
    required int pageSize,
    required int offset,
  });

  @override
  @Query('select '
      'u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, '
      'u.invertible, u.oob, '
      'coalesce(u.value_type, g.value_type) value_type, '
      'coalesce(u.min_value, g.min_value) min_value, '
      'coalesce(u.max_value, g.max_value) max_value '
      'from $conversionParamsTableName p '
      'inner join $unitsTableName u on u.unit_group_id = p.unit_group_id '
      'inner join $unitGroupsTableName g on g.id = u.unit_group_id '
      'where p.id = :paramId '
      'and (u.name like :searchString or u.code like :searchString) '
      'order by u.code '
      'limit :pageSize offset :offset')
  Future<List<UnitEntity>> searchWithParamId({
    required String searchString,
    required int paramId,
    required int pageSize,
    required int offset,
  });

  @override
  @Query('select '
      'u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, '
      'u.invertible, u.oob, '
      'coalesce(u.value_type, g.value_type) value_type, '
      'coalesce(u.min_value, g.min_value) min_value, '
      'coalesce(u.max_value, g.max_value) max_value '
      'from $unitsTableName u '
      'inner join $unitGroupsTableName g on g.id = u.unit_group_id '
      'where g.id = :unitGroupId '
      'and u.code = :code')
  Future<UnitEntity?> getByCode(int unitGroupId, String code);

  @override
  @Query('select '
      'u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, '
      'u.invertible, u.oob, '
      'coalesce(u.value_type, g.value_type) value_type, '
      'coalesce(u.min_value, g.min_value) min_value, '
      'coalesce(u.max_value, g.max_value) max_value '
      'from $unitsTableName u '
      'inner join $unitGroupsTableName g on g.id = u.unit_group_id '
      'where g.id = :unitGroupId '
      'and cast(u.coefficient as int) = 1 '
      'limit 2')
  Future<List<UnitEntity>> getBaseUnits(int unitGroupId);

  @override
  @Query('select '
      'u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, '
      'u.invertible, u.oob, '
      'coalesce(u.value_type, g.value_type) value_type, '
      'coalesce(u.min_value, g.min_value) min_value, '
      'coalesce(u.max_value, g.max_value) max_value '
      'from $unitsTableName u '
      'inner join $unitGroupsTableName g on g.id = u.unit_group_id '
      'where u.id = :id '
      'limit 1')
  Future<UnitEntity?> getUnit(int id);

  @override
  @Query('select '
      'u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, '
      'u.invertible, u.oob, '
      'coalesce(u.value_type, g.value_type) value_type, '
      'coalesce(u.min_value, g.min_value) min_value, '
      'coalesce(u.max_value, g.max_value) max_value '
      'from $unitsTableName u '
      'inner join $unitGroupsTableName g on g.id = u.unit_group_id '
      'where u.id in (:ids)')
  Future<List<UnitEntity>> getUnitsByIds(List<int> ids);

  @override
  @Query('select '
      'u.id, u.name, u.code, u.symbol, u.coefficient, u.unit_group_id, '
      'u.invertible, u.oob, '
      'coalesce(u.value_type, g.value_type) value_type, '
      'coalesce(u.min_value, g.min_value) min_value, '
      'coalesce(u.max_value, g.max_value) max_value '
      'from $unitsTableName u '
      'inner join $unitGroupsTableName g on g.id = u.unit_group_id '
      'where 1=1 '
      'and g.name = :unitGroupName '
      'and u.unit_group_id = g.id '
      'and u.code in (:codes)')
  Future<List<UnitEntity>> getUnitsByCodes(
    String unitGroupName,
    List<String> codes,
  );

  @override
  Future<List<UnitEntity>> updateUnitsCoefficients(
    sqlite.Database db,
    String unitGroupName,
    Map<String, double?> codeToCoefficient,
  ) async {
    List<UnitEntity> savedEntities = await getUnitsByCodes(
      unitGroupName,
      codeToCoefficient.keys.toList(),
    );

    List<UnitEntity> patchEntities = savedEntities
        .map(
          (entity) => UnitEntity.coalesce(
            savedEntity: entity,
            coefficient: codeToCoefficient[entity.code],
          ),
        )
        .toList();

    await updateBatch(db, patchEntities);
    return patchEntities;
  }

  @override
  @Insert(onConflict: OnConflictStrategy.fail)
  Future<int> insert(UnitEntity unit);

  @override
  Future<void> updateBatch(sqlite.Database db, List<UnitEntity> units) async {
    var batch = db.batch();
    for (UnitEntity entity in units) {
      batch.update(
        unitsTableName,
        {
          'coefficient': entity.coefficient,
        },
        where: 'unit_group_id = ? and code = ?',
        whereArgs: [
          entity.unitGroupId,
          entity.code,
        ],
        conflictAlgorithm: sqlite.ConflictAlgorithm.fail,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  @Update()
  Future<int> update(UnitEntity unit);

  @override
  @Query("delete from $unitsTableName where id in (:ids)")
  Future<void> remove(List<int> ids);
}
