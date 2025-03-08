import 'package:convertouch/data/entities/conversion_unit_value_entity.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

abstract class ConversionItemDao {
  const ConversionItemDao();

  Future<List<ConversionUnitValueEntity>> getByConversionId(int conversionId);

  Future<void> insertBatch(
    sqlite.Database db,
    List<ConversionUnitValueEntity> conversionItems,
  );

  Future<void> removeByConversionId(int conversionId);
}
