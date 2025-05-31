import 'package:convertouch/data/dao/conversion_param_value_dao.dart';
import 'package:convertouch/data/entities/conversion_item_value_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

@dao
abstract class ConversionParamValueDaoDb extends ConversionParamValueDao {
  @override
  @Query('select * from $conversionParamValuesTableName '
      'where conversion_id = :conversionId '
      'order by sequence_num')
  Future<List<ConversionParamValueEntity>> getByConversionId(int conversionId);

  @override
  Future<void> insertBatch(
    sqlite.Database db,
    List<ConversionParamValueEntity> conversionParamValues,
  ) async {
    var batch = db.batch();
    for (ConversionParamValueEntity entity in conversionParamValues) {
      batch.insert(
        conversionParamValuesTableName,
        entity.toRow(),
        conflictAlgorithm: sqlite.ConflictAlgorithm.fail,
      );
    }

    await batch.commit(noResult: true);
  }

  @override
  @Query('delete from $conversionParamValuesTableName '
      'where conversion_id = :conversionId')
  Future<void> removeByConversionId(int conversionId);
}
