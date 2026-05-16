import 'package:convertouch/data/entities/conversion_param_entity.dart';

abstract class ConversionParamDao {
  const ConversionParamDao();

  Future<ConversionParamEntity?> get(int paramId);

  Future<List<ConversionParamEntity>> getBySetId(int setId);
}