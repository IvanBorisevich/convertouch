import 'package:convertouch/data/dao/conversion_param_dao.dart';
import 'package:convertouch/data/entities/conversion_param_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ConversionParamDaoDb extends ConversionParamDao {

  @override
  @Query('SELECT p.* FROM $conversionParamsTableName p '
      'WHERE p.param_set_id = :setId')
  Future<List<ConversionParamEntity>> get(int setId);
}