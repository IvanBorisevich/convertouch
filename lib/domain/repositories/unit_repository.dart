import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:either_dart/either.dart';

abstract class UnitRepository {
  const UnitRepository();

  Future<Either<Failure, List<UnitModel>>> fetchUnitsOfGroup(int unitGroupId);

  Future<Either<Failure, UnitModel?>> getBaseUnit(int unitGroupId);

  Future<Either<Failure, int>> addUnit(UnitModel unit);
}