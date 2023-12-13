import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:either_dart/either.dart';

abstract class UnitRepository {
  const UnitRepository();

  Future<Either<Failure, List<UnitModel>>> fetchUnits(int unitGroupId);

  Future<Either<Failure, List<UnitModel>>> searchUnits(int unitGroupId, String searchString);

  Future<Either<Failure, UnitModel?>> getDefaultBaseUnit(int unitGroupId);

  Future<Either<Failure, int>> addUnit(UnitModel unit);

  Future<Either<Failure, void>> removeUnits(List<int> unitIds);
}