import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:either_dart/either.dart';

class UnitRepositoryImpl extends UnitRepository {
  final UnitDao unitDao;

  const UnitRepositoryImpl(this.unitDao);

  @override
  Future<Either<Failure, List<UnitModel>>> fetchUnitsOfGroup(
    int unitGroupId,
  ) async {
    try {
      final result = await unitDao.fetchUnitsOfGroup(unitGroupId);
      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)!).toList(),
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when fetching units of the group with id = "
            "$unitGroupId: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, UnitModel?>> getBaseUnit(int unitGroupId) async {
    try {
      var result = await unitDao.getBaseUnit(unitGroupId);
      result ??= await unitDao.getFirstUnit(unitGroupId);
      return Right(UnitTranslator.I.toModel(result));
    } catch (e) {
      return Left(
        DatabaseFailure("Error when retrieving base unit "
            "of the group with id = $unitGroupId: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, int>> addUnit(UnitModel unit) async {
    try {
      final result = await unitDao.addUnit(UnitTranslator.I.fromModel(unit)!);
      return Right(result);
    } catch (e) {
      return Left(
        DatabaseFailure("Error when adding a unit: $e"),
      );
    }
  }
}
