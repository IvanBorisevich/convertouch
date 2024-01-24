import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:either_dart/either.dart';

abstract class UnitRepository {
  const UnitRepository();

  Future<Either<Failure, List<UnitModel>>> getByGroupId(int unitGroupId);

  Future<Either<Failure, List<UnitModel>>> search(
    int unitGroupId,
    String searchString,
  );

  Future<Either<Failure, List<UnitModel>>> getByIds(List<int> ids);

  Future<Either<Failure, Map<int, UnitModel>>> getByCodesAsMap(
    int unitGroupId,
    List<String> codes,
  );

  Future<Either<Failure, UnitModel?>> get(int id);

  Future<Either<Failure, UnitModel?>> getBaseUnit(int unitGroupId);

  Future<Either<Failure, int>> add(UnitModel unit);

  Future<Either<Failure, List<UnitModel>>> updateCoefficientsByCodes(
    int unitGroupId,
    Map<String, double?> codeToCoefficient,
  );

  Future<Either<Failure, void>> remove(List<int> unitIds);
}
