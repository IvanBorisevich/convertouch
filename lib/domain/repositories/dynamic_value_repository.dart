import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:either_dart/either.dart';

abstract class DynamicValueRepository {
  const DynamicValueRepository();

  Future<Either<ConvertouchException, DynamicValueModel?>> get({
    required UnitModel unit,
    ConversionParamSetValueModel? params,
  });
}
