import 'package:convertouch/data/entities/conversion_item_entity.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

abstract class ConversionItemDao {
  const ConversionItemDao();

  Future<List<ConversionItemEntity>> getByConversionId(int conversionId);

  Future<void> insertBatch(
    sqlite.Database db,
    List<ConversionItemEntity> conversionItems,
  );

  Future<void> removeByConversionId(int conversionId);
}
