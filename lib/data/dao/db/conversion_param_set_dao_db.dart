import 'package:convertouch/data/dao/conversion_param_set_dao.dart';
import 'package:convertouch/data/entities/conversion_param_set_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ConversionParamSetDaoDb extends ConversionParamSetDao {

  @override
  @Query('SELECT p.* FROM $conversionParamSetsTableName p '
      'WHERE p.group_id = :groupId')
  Future<List<ConversionParamSetEntity>> get(int groupId);
}