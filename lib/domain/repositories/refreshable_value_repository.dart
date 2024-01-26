import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshable_value_model.dart';
import 'package:either_dart/either.dart';

abstract class RefreshableValueRepository {
  const RefreshableValueRepository();

  Future<Either<ConvertouchException, RefreshableValueModel?>> get(int unitId);

  Future<Either<ConvertouchException, List<RefreshableValueModel>>> getList(
    List<int> unitIds,
  );

  Future<Either<ConvertouchException, List<RefreshableValueModel>>> updateValuesByCodes(
    int unitGroupId,
    Map<String, String?> codeToValue,
  );
}
