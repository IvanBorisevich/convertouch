import 'package:convertouch/data/dao/conversion_param_unit_dao.dart';
import 'package:convertouch/data/entities/conversion_param_unit_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ConversionParamUnitDaoDb extends ConversionParamUnitDao {

  @override
  @Query('SELECT CASE count(1) WHEN 0 THEN 0 ELSE 1 END '
      'FROM $conversionParamUnitsTableName '
      'WHERE param_id = :paramId ')
  Future<int?> hasPossibleUnits(int paramId);
}