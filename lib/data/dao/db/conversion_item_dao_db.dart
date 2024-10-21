import 'package:convertouch/data/dao/conversion_item_dao.dart';
import 'package:convertouch/data/entities/conversion_item_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

@dao
abstract class ConversionItemDaoDb extends ConversionItemDao {
  @override
  @Query('select * from $conversionItemsTableName '
      'where conversion_id = :conversionId '
      'order by sequence_num')
  Future<List<ConversionItemEntity>> getByConversionId(int conversionId);

  @override
  @Query('select * from $conversionItemsTableName '
      'where conversion_id = :conversionId '
      'and is_source = 1 '
      'limit 1')
  Future<ConversionItemEntity?> getSourceItem(int conversionId);

  @override
  Future<void> insertBatch(
    sqlite.Database db,
    List<ConversionItemEntity> conversionItems,
  ) async {
    var batch = db.batch();
    for (ConversionItemEntity entity in conversionItems) {
      db.insert(
        conversionItemsTableName,
        entity.toDbRow(),
        conflictAlgorithm: sqlite.ConflictAlgorithm.fail,
      );
    }

    batch.commit(noResult: true);
  }

  @override
  @Query('delete from $conversionItemsTableName '
      'where conversion_id = :conversionId')
  Future<void> removeByConversionId(int conversionId);
}
