import 'package:convertouch/domain/model/dynamic_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/dynamic_value_repository.dart';
import 'package:either_dart/src/either.dart';

class MockDynamicValueRepository extends DynamicValueRepository {
  const MockDynamicValueRepository();

  @override
  Future<Either<ConvertouchException, DynamicValueModel?>> get(
    int unitId,
  ) async {
    return const Right(null);
  }

  @override
  Future<Either<ConvertouchException, List<DynamicValueModel>>> getList(
    List<int> unitIds,
  ) async {
    return const Right([]);
  }
}
