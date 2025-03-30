import 'package:convertouch/data/entities/conversion_item_value_entity.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

abstract class ConversionUnitValueDao {
  const ConversionUnitValueDao();

  Future<List<ConversionUnitValueEntity>> getByConversionId(int conversionId);

  Future<void> insertBatch(
    sqlite.Database db,
    List<ConversionUnitValueEntity> conversionUnitValues,
  );

  Future<void> removeByConversionId(int conversionId);
}
