import 'package:convertouch/data/dao/conversion_param_set_dao.dart';
import 'package:convertouch/data/entities/conversion_param_set_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ConversionParamSetDaoDb extends ConversionParamSetDao {
  @override
  @Query('SELECT * FROM $conversionParamSetsTableName '
      'WHERE group_id = :groupId '
      'and name like :searchString '
      'limit :pageSize offset :offset')
  Future<List<ConversionParamSetEntity>> getBySearchString({
    required String searchString,
    required int groupId,
    required int pageSize,
    required int offset,
  });

  @override
  @Query('SELECT * FROM $conversionParamSetsTableName '
      'WHERE group_id = :groupId '
      'AND mandatory = 1 '
      'limit 1')
  Future<ConversionParamSetEntity?> getFirstMandatory(int groupId);

  @override
  @Query('SELECT count(1) '
      'FROM $conversionParamSetsTableName '
      'WHERE group_id = :groupId '
      'AND (mandatory != 1 or mandatory is null)')
  Future<int?> getNumOfOptional(int groupId);
}
