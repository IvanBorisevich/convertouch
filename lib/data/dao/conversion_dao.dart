import 'package:convertouch/data/entities/conversion_entity.dart';

abstract class ConversionDao {
  const ConversionDao();

  Future<ConversionEntity?> getLast(int unitGroupId);

  Future<int> insert(ConversionEntity conversion);

  Future<int> update(ConversionEntity conversion);

  Future<void> removeByGroupIds(List<int> unitGroupIds);
}