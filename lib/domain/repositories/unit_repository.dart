import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:either_dart/either.dart';

abstract class UnitRepository {
  const UnitRepository();

  Future<Either<ConvertouchException, List<UnitModel>>> getPageByGroupId({
    required int unitGroupId,
    required int pageNum,
    required int pageSize,
  });

  Future<Either<ConvertouchException, List<UnitModel>>> getPageByParamId({
    required int paramId,
    required int pageNum,
    required int pageSize,
  });

  Future<Either<ConvertouchException, List<UnitModel>>> search({
    required int unitGroupId,
    required String searchString,
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
