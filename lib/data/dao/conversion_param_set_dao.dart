import 'package:convertouch/data/entities/conversion_param_set_entity.dart';

abstract class ConversionParamSetDao {
  const ConversionParamSetDao();

  Future<List<ConversionParamSetEntity>> getBySearchString({
    required String searchString,
    required int groupId,
    required int pageSize,
    required int offset,
  });

  Future<ConversionParamSetEntity?> getFirstMandatory(int groupId);

  Future<int?> getNumOfOptional(int groupId);
}