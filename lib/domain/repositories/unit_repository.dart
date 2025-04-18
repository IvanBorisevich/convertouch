import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:either_dart/either.dart';

abstract class UnitRepository {
  const UnitRepository();

  Future<Either<ConvertouchException, List<UnitModel>>> searchWithGroupId({
    required int unitGroupId,
    String? searchString,
    required int pageNum,
    required int pageSize,
  });

  Future<Either<ConvertouchException, List<UnitModel>>> searchWithParamId({
    required int paramId,
    String? searchString,
    required int pageNum,
    required int pageSize,
  });

  Future<Either<ConvertouchException, List<UnitModel>>> getByIds(List<int> ids);

  Future<Either<ConvertouchException, Map<int, UnitModel>>> getByCodesAsMap(
    String unitGroupName,
    List<String> codes,
  );

  Future<Either<ConvertouchException, UnitModel?>> get(int id);

  Future<Either<ConvertouchException, List<UnitModel>>> getBaseUnits(
    int unitGroupId,
  );

  Future<Either<ConvertouchException, UnitModel>> add(UnitModel unit);

  Future<Either<ConvertouchException, void>> remove(List<int> unitIds);

  Future<Either<ConvertouchException, UnitModel>> update(UnitModel unit);
}
