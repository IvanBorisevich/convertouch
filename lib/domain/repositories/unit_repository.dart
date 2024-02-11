import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:either_dart/either.dart';

abstract class UnitRepository {
  const UnitRepository();

  Future<Either<ConvertouchException, List<UnitModel>>> getByGroupId(
      int unitGroupId);

  Future<Either<ConvertouchException, List<UnitModel>>> search(
    int unitGroupId,
    String searchString,
  );

  Future<Either<ConvertouchException, List<UnitModel>>> getByIds(List<int> ids);

  Future<Either<ConvertouchException, Map<int, UnitModel>>> getByCodesAsMap(
    String unitGroupName,
    List<String> codes,
  );

  Future<Either<ConvertouchException, UnitModel?>> get(int id);

  Future<Either<ConvertouchException, UnitModel>> getBaseUnit(int unitGroupId);

  Future<Either<ConvertouchException, int>> add(UnitModel unit);

  Future<Either<ConvertouchException, void>> remove(List<int> unitIds);

  Future<Either<ConvertouchException, void>> update(UnitModel unit);
}
