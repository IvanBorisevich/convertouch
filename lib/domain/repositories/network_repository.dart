import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/value_model.dart';
import 'package:either_dart/either.dart';

abstract class NetworkRepository {
  const NetworkRepository();

  Future<Either<ConvertouchException, DynamicDataModel?>> fetchByParams({
    required ConversionParamSetValueModel params,
  });

  Future<Either<ConvertouchException, List<ValueModel>>> fetchList({
    required ConvertouchListType listType,
    required ConversionParamSetValueModel params,
    required int pageSize,
    required int pageNum,
  });
}
