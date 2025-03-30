import 'package:convertouch/data/entities/conversion_item_value_entity.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

abstract class ConversionParamValueDao {
  const ConversionParamValueDao();

  Future<List<ConversionParamValueEntity>> getByConversionId(int conversionId);

  Future<void> insertBatch(
    sqlite.Database db,
    List<ConversionParamValueEntity> conversionParamValues,
  );

  Future<void> removeByConversionId(int conversionId);
}
