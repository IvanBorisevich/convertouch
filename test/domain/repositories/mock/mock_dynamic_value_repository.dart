import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:either_dart/src/either.dart';

class MockDynamicValueRepository extends DynamicValueRepository {
  const MockDynamicValueRepository();

  @override
  Future<Either<ConvertouchException, DynamicValueModel?>> get({
    required UnitModel unit,
    ConversionParamSetValueModel? params,
  }) async {
    return const Right(null);
  }
}
