import 'package:convertouch/domain/model/dynamic_value_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:either_dart/either.dart';

abstract class DynamicValueRepository {
  const DynamicValueRepository();

  Future<Either<ConvertouchException, DynamicValueModel>> get(int unitId);

  Future<Either<ConvertouchException, List<DynamicValueModel>>> getList(
    List<int> unitIds,
  );
}
