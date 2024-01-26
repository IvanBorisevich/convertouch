import 'package:collection/collection.dart';
import 'package:convertouch/data/dao/job_data_source_dao.dart';
import 'package:convertouch/data/dao/refreshing_job_dao.dart';
import 'package:convertouch/data/dao/unit_group_dao.dart';
import 'package:convertouch/data/entities/job_data_source_entity.dart';
import 'package:convertouch/data/entities/refreshing_job_entity.dart';
import 'package:convertouch/data/entities/unit_group_entity.dart';
import 'package:convertouch/data/translators/refreshing_job_translator.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:either_dart/either.dart';

class RefreshingJobRepositoryImpl extends RefreshingJobRepository {
  final RefreshingJobDao refreshingJobDao;
  final UnitGroupDao unitGroupDao;
  final JobDataSourceDao jobDataSourceDao;

  const RefreshingJobRepositoryImpl({
    required this.unitGroupDao,
    required this.refreshingJobDao,
    required this.jobDataSourceDao,
  });

  @override
  Future<Either<ConvertouchException, List<RefreshingJobModel>>>
      getAll() async {
    try {
      final refreshingJobs = await refreshingJobDao.getAll();
      final refreshableGroups = await unitGroupDao.getRefreshableGroups();

      final List<int> selectedDataSourceIds = refreshingJobs
          .map((item) => item.selectedDataSourceId)
          .whereNotNull()
          .toList();

      final selectedDataSources =
          await jobDataSourceDao.getByIds(selectedDataSourceIds);

      return Right(
        _join(
          refreshingJobs,
          refreshableGroups,
          selectedDataSources,
        ),
      );
    } catch (e) {
      return Left(
        DatabaseException(
          message: "Error when fetching refreshing jobs: $e",
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, RefreshingJobModel?>> get(int id) async {
    try {
      final jobEntity = await refreshingJobDao.get(id);
      if (jobEntity == null) {
        return const Right(null);
      }

      final groupEntity = await unitGroupDao.get(jobEntity.unitGroupId);
      final selectedDataSourceEntity =
          await jobDataSourceDao.get(jobEntity.selectedDataSourceId ?? -1);

      return Right(
        _joinSingle(jobEntity, groupEntity, selectedDataSourceEntity),
      );
    } catch (e) {
      return Left(
        DatabaseException(
          message: "Error when fetching refreshing job by id = $id: $e",
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, RefreshingJobModel?>> getByGroupId(
    int unitGroupId,
  ) async {
    try {
      final jobEntity = await refreshingJobDao.getByGroupId(unitGroupId);
      if (jobEntity == null) {
        return const Right(null);
      }

      final groupEntity = await unitGroupDao.get(jobEntity.unitGroupId);
      final selectedDataSourceEntity =
          await jobDataSourceDao.get(jobEntity.selectedDataSourceId ?? -1);

      return Right(
        _joinSingle(jobEntity, groupEntity, selectedDataSourceEntity),
      );
    } catch (e) {
      return Left(
        DatabaseException(
          message: "Error when fetching refreshing job "
              "by unit group id = $unitGroupId: $e",
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, void>> update(
      RefreshingJobModel model) async {
    try {
      await refreshingJobDao.update(RefreshingJobTranslator.I.fromModel(model));
      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseException(
          message: "Error when updating job '${model.name}': $e",
        ),
      );
    }
  }

  List<RefreshingJobModel> _join(
    List<RefreshingJobEntity> jobs,
    List<UnitGroupEntity> groups,
    List<JobDataSourceEntity> selectedDataSources,
  ) {
    Map<int, UnitGroupEntity> groupsMap = {}..addEntries(
        groups.map((entity) => MapEntry(entity.id!, entity)).toList());

    Map<int, JobDataSourceEntity> selectedDataSourcesMap = {}..addEntries(
        selectedDataSources
            .map((entity) => MapEntry(entity.id!, entity))
            .toList());

    return jobs
        .map(
          (jobEntity) => _joinSingle(
            jobEntity,
            groupsMap[jobEntity.unitGroupId],
            selectedDataSourcesMap[jobEntity.selectedDataSourceId],
          ),
        )
        .toList();
  }

  RefreshingJobModel _joinSingle(
    RefreshingJobEntity job,
    UnitGroupEntity? group,
    JobDataSourceEntity? selectedDataSource,
  ) {
    return RefreshingJobTranslator.I.toModel(
      job,
      unitGroupEntity: group,
      selectedDataSource: selectedDataSource,
    );
  }
}
