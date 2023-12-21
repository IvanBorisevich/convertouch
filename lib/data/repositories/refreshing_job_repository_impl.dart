import 'package:convertouch/data/dao/refreshing_job_dao.dart';
import 'package:convertouch/data/dao/unit_group_dao.dart';
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
      final unitGroups = await unitGroupDao.getRefreshableGroups();

      print("Unit groups dynamic: $unitGroups");

      final resultRefreshingJobs = refreshingJobs
          .map(
            (entity) => RefreshingJobTranslator.I.toModel(
              entity,
              unitGroup: unitGroups
                  .where((unitGroup) => unitGroup.name == entity.unitGroupName)
                  .firstOrNull,
            ),
          )
          .toList();

      return Right(resultRefreshingJobs);
    } catch (e) {
      return Left(
        InternalFailure("Error when fetching refreshing jobs: $e"),
      );
    }
  }
}
