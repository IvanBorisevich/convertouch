import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/translators/unit_group_translator.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/unit_group_repository.dart';
import 'package:either_dart/either.dart';

class UnitGroupRepositoryImpl extends UnitGroupRepository {
  final UnitGroupDao unitGroupDao;

  const UnitGroupRepositoryImpl(this.unitGroupDao);

  @override
  Future<Either<ConvertouchException, List<UnitGroupModel>>> search({
    String? searchString,
    required int pageNum,
    required int pageSize,
  }) async {
    try {
      String searchPattern = searchString != null && searchString.isNotEmpty
          ? '%$searchString%'
          : '%';

      List<UnitGroupEntity> result = await unitGroupDao.getBySearchString(
        searchString: searchPattern,
        pageSize: pageSize,
        offset: pageNum * pageSize,
      );

      return Right(
        result.map((entity) => UnitGroupTranslator.I.toModel(entity)).toList(),
      );
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when searching unit groups",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, UnitGroupModel>> add(
    UnitGroupModel unitGroup,
  ) async {
    try {
      final existingGroup = await unitGroupDao.getByName(unitGroup.name);
      if (existingGroup == null) {
        final addedGroupId = await unitGroupDao
            .insert(UnitGroupTranslator.I.fromModel(unitGroup));
        return Right(
          unitGroup.copyWith(
            id: addedGroupId,
          ),
        );
      } else {
        return Left(
          DatabaseException(
            message: "Unit group '${existingGroup.name}' already exists",
            stackTrace: null,
            dateTime: DateTime.now(),
            severity: ExceptionSeverity.info,
          ),
        );
      }
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when adding a unit group",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, UnitGroupModel?>> get(
    int unitGroupId,
  ) async {
    try {
      final result = await unitGroupDao.get(unitGroupId);
      if (result == null) {
        return Left(
          DatabaseException(
            message: "Unit group with id = $unitGroupId not found",
            stackTrace: null,
            dateTime: DateTime.now(),
          ),
        );
      }
      return Right(UnitGroupTranslator.I.toModel(result));
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when searching a unit group by id",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, void>> remove(
    List<int> unitGroupIds,
  ) async {
    try {
      await unitGroupDao.remove(unitGroupIds);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when deleting unit groups by ids",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, UnitGroupModel>> update(
    UnitGroupModel unitGroup,
  ) async {
    try {
      await unitGroupDao.update(UnitGroupTranslator.I.fromModel(unitGroup));
      return Right(unitGroup);
    } catch (e, stackTrace) {
      return Left(
        DatabaseException(
          message: "Error when updating unit group by id",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
