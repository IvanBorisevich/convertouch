import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/entities/conversion_param_units.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

@dao
abstract class UnitDaoDb extends UnitDao {
  @override
  @Query('select * from $unitsTableName '
      'where unit_group_id = :unitGroupId '
      'order by code '
      'limit :pageSize offset :offset')
  Future<List<UnitEntity>> getAll({
    required int unitGroupId,
    required int pageSize,
    required int offset,
  });

  @override
  @Query('select * from $unitsTableName '
      'where unit_group_id = :unitGroupId '
      'and (name like :searchString or code like :searchString) '
      'order by code '
      'limit :pageSize offset :offset')
  Future<List<UnitEntity>> getBySearchString({
    required String searchString,
    required int unitGroupId,
    required int pageSize,
    required int offset,
  });

  @override
  @Query('select * from $unitsTableName '
      'where unit_group_id = :unitGroupId '
      'and code = :code')
  Future<UnitEntity?> getByCode(int unitGroupId, String code);

  @override
  @Query('select u.* '
      'from $unitsTableName u '
      'inner join $conversionParamUnitsTableName p on p.unit_id = u.id '
      'where p.param_id = :paramId '
      'order by u.code '
      'limit :pageSize offset :offset')
  Future<List<UnitEntity>> getByParamId({
    required int paramId,
    required int pageSize,
    required int offset,
  });

  @override
  @Query('select * from $unitsTableName '
      'where unit_group_id = :unitGroupId '
      'and cast(coefficient as int) = 1 '
      'limit 2')
  Future<List<UnitEntity>> getBaseUnits(int unitGroupId);

  @override
  @Query('select * from $unitsTableName where id = :id limit 1')
  Future<UnitEntity?> getUnit(int id);

  @override
  @Query('select * from $unitsTableName where id in (:ids)')
  Future<List<UnitEntity>> getUnitsByIds(List<int> ids);

  @override
  @Query('select u.* '
      'from $unitsTableName u '
      'inner join $unitGroupsTableName g '
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
