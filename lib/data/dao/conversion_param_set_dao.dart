import 'package:convertouch/data/entities/conversion_param_set_entity.dart';

abstract class ConversionParamSetDao {
  const ConversionParamSetDao();

  Future<List<ConversionParamSetEntity>> get(int groupId);

  Future<ConversionParamSetEntity?> getFirstMandatory(int groupId);

  Future<int?> getNumOfOptional(int groupId);
}