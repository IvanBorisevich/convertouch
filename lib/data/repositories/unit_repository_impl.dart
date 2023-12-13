import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/translators/unit_translator.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/unit_model.dart';
import 'package:convertouch/domain/repositories/unit_repository.dart';
import 'package:either_dart/either.dart';

class UnitRepositoryImpl extends UnitRepository {
  final UnitDao unitDao;
  final UnitGroupDao unitGroupDao;

  const UnitRepositoryImpl({
    required this.unitDao,
    required this.unitGroupDao,
  });

  @override
  Future<Either<Failure, List<UnitModel>>> fetchUnits(int unitGroupId) async {
    try {
      final result = await unitDao.getAll(unitGroupId);
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
  Future<Either<Failure, List<UnitModel>>> searchUnits(
      int unitGroupId, String searchString) async {
    try {
      List<UnitEntity> result;
      if (searchString.isNotEmpty) {
        result = await unitDao.getBySearchString(
          unitGroupId,
          '%$searchString%',
        );
      } else {
        result = [];
      }
      return Right(
        result.map((entity) => UnitTranslator.I.toModel(entity)!).toList(),
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when searching units: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, UnitModel?>> getDefaultBaseUnit(
      int unitGroupId) async {
    try {
      var result = await unitDao.getFirstUnit(unitGroupId);
      return Right(UnitTranslator.I.toModel(result));
    } catch (e) {
      return Left(
        DatabaseFailure("Error when retrieving default base unit "
            "of the group with id = $unitGroupId: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, int>> addUnit(UnitModel unit) async {
    try {
      final existingUnit = await unitDao.getByName(unit.unitGroupId, unit.name);
      if (existingUnit == null) {
        final result = await unitDao.insert(UnitTranslator.I.fromModel(unit)!);
        return Right(result);
      } else {
        return const Right(-1);
      }
    } catch (e) {
      return Left(
        DatabaseFailure("Error when adding a unit: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> removeUnits(List<int> unitIds) async {
    try {
      await unitDao.remove(unitIds);
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(
          "Error when deleting units by ids = $unitIds: $e",
        ),
      );
    }
  }
}
