import 'package:convertouch/data/dao/conversion_unit_value_dao.dart';
import 'package:convertouch/data/entities/conversion_item_value_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

@dao
abstract class ConversionUnitValueDaoDb extends ConversionUnitValueDao {
  @override
  @Query('select * from $conversionUnitValuesTableName '
      'where conversion_id = :conversionId '
      'order by sequence_num')
  Future<List<ConversionUnitValueEntity>> getByConversionId(int conversionId);

  @override
  Future<void> insertBatch(
    sqlite.Database db,
    List<ConversionUnitValueEntity> conversionUnitValues,
  ) async {
    var batch = db.batch();
    for (ConversionUnitValueEntity entity in conversionUnitValues) {
      batch.insert(
        conversionUnitValuesTableName,
        entity.toRow(),
        conflictAlgorithm: sqlite.ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  @Query('delete from $conversionUnitValuesTableName '
      'where conversion_id = :conversionId')
  Future<void> removeByConversionId(int conversionId);
}
