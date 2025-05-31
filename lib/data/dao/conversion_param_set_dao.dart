import 'package:convertouch/data/entities/conversion_param_set_entity.dart';

abstract class ConversionParamSetDao {
  const ConversionParamSetDao();

  Future<List<ConversionParamSetEntity>> getBySearchString({
    required String searchString,
    required int groupId,
    required int pageSize,
    required int offset,
  });

  Future<List<ConversionParamSetEntity>> getByIds(List<int> ids);

  Future<ConversionParamSetEntity?> getFirstMandatory(int groupId);

  Future<int?> getCount(int groupId);
}