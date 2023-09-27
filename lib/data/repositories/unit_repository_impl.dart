import 'package:convertouch/data/dao/unit_dao.dart';
import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/entities/unit_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
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
  Future<Either<Failure, List<UnitModel>>> fetchUnitsOfGroup(
    int unitGroupId,
  ) async {
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
  Future<Either<Failure, UnitModel?>> getBaseUnit(int unitGroupId) async {
    try {
      var result = await unitDao.getBaseUnit(unitGroupId);
      result ??= await unitDao.getFirst(unitGroupId);
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
      final result = await unitDao.insert(UnitTranslator.I.fromModel(unit)!);
      return Right(result);
    } catch (e) {
      return Left(
        DatabaseFailure("Error when adding a unit: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> importFromJson(
    Map<String, dynamic> json,
  ) async {
    try {
      return _insertJson(json).then(
        (value) => const Right(null),
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when importing units from json: $e"),
      );
    }
  }

  Future<void> _insertJson(Map<String, dynamic> json) async {
    Future.forEach(json['unitGroups'], (unitGroupMap) async {
      int unitGroupId = await _insertGroup(unitGroupMap as Map<String, dynamic>);
      await _insertUnits(unitGroupMap, unitGroupId);
    });
  }

  Future<int> _insertGroup(Map<String, dynamic> unitGroupMap) async {
    return Future.sync(() {
      return UnitGroupEntity.fromJson(unitGroupMap);
    }).then((unitGroup) async {
      return Future.sync(
        () => unitGroupDao.insert(unitGroup),
      ).onError(
        (error, stackTrace) => unitGroupDao.update(unitGroup),
      );
    });
  }

  Future<void> _insertUnits(
    Map<String, dynamic> unitGroupMap,
    int unitGroupId,
  ) async {
    return Future.sync(() {
      return unitGroupMap['units']
          .map(
            (unitMap) => UnitEntity.fromJson(
              unitMap,
              unitGroupId: unitGroupId,
            ),
          )
          .toList();
    }).then((units) {
      for (UnitEntity unit in units) {
        Future.sync(
              () => unitDao.insert(unit),
        ).onError(
              (error, stackTrace) => unitDao.update(unit),
        );
      }
    });
  }
}
