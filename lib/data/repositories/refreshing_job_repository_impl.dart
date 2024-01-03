import 'package:convertouch/data/dao/refreshing_job_dao.dart';
import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/entities/refreshing_job_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/translators/refreshing_job_translator.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:either_dart/either.dart';

class RefreshingJobRepositoryImpl extends RefreshingJobRepository {
  final RefreshingJobDao refreshingJobDao;
  final UnitGroupDao unitGroupDao;

  const RefreshingJobRepositoryImpl({
    required this.unitGroupDao,
    required this.refreshingJobDao,
  });

  @override
  Future<Either<Failure, List<RefreshingJobModel>>> fetchAll() async {
    try {
      final refreshingJobs = await refreshingJobDao.getAll();
      final refreshableGroups = await unitGroupDao.getRefreshableGroups();

      return Right(_join(refreshingJobs, refreshableGroups));
    } catch (e) {
      return Left(
        InternalFailure("Error when fetching refreshing jobs: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, RefreshingJobModel>> fetch(int id) async {
    try {
      final entity = await refreshingJobDao.get(id);
      if (entity == null) {
        return Left(
          DatabaseFailure(
            "Refreshing job with id = $id not found",
          ),
        );
      }
      return Right(RefreshingJobTranslator.I.toModel(entity));
    } catch (e) {
      return Left(
        InternalFailure("Error when fetching refreshing job by id = $id: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> update(RefreshingJobModel model) async {
    try {
      await refreshingJobDao.update(RefreshingJobTranslator.I.fromModel(model));
      return const Right(null);
    } catch (e) {
      return Left(
        InternalFailure("Error when updating refreshing job "
            "by id = ${model.id}: $e"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updatePatch(
    RefreshingJobModel model, {
    bool patchWithNulls = false,
  }) async {
    try {
      RefreshingJobEntity entityPatch =
          RefreshingJobTranslator.I.fromModel(model);
      RefreshingJobEntity? entitySaved = await refreshingJobDao.get(model.id!);

      if (entitySaved == null) {
        return Left(
          DatabaseFailure(
            "Refreshing job with id = ${model.id} not found",
          ),
        );
      }

      RefreshingJobEntity entityResult = RefreshingJobEntity.coalesce(
        entitySaved,
        cronId: entityPatch.cronId,
      );
      await refreshingJobDao.update(entityResult);

      return const Right(null);
    } catch (e) {
      return Left(
        InternalFailure("Error when updating refreshing job cron: $e"),
      );
    }
  }

  List<RefreshingJobModel> _join(
    List<RefreshingJobEntity> jobs,
    List<UnitGroupEntity> groups,
  ) {
    Map<int, UnitGroupEntity> groupsMap = {}..addEntries(
        groups.map((entity) => MapEntry(entity.id!, entity)).toList());

    return jobs
        .map(
          (jobEntity) => RefreshingJobTranslator.I.toModel(
            jobEntity,
            unitGroupEntity: groupsMap[jobEntity.unitGroupId],
          ),
        )
        .toList();
  }
}
