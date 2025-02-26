import 'package:convertouch/data/entities/conversion_param_entity.dart';

abstract class ConversionParamDao {
  const ConversionParamDao();

  Future<List<ConversionParamEntity>> get(int setId);
}