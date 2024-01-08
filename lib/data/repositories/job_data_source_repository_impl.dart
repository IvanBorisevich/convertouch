import 'package:convertouch/data/dao/job_data_source_dao.dart';
import 'package:convertouch/data/translators/job_data_source_translator.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/job_data_source_model.dart';
import 'package:convertouch/domain/repositories/job_data_source_repository.dart';
import 'package:either_dart/either.dart';

class JobDataSourceRepositoryImpl extends JobDataSourceRepository {
  final JobDataSourceDao jobDataSourceDao;

  const JobDataSourceRepositoryImpl(this.jobDataSourceDao);

  @override
  Future<Either<Failure, List<JobDataSourceModel>>> getByJobId(
    int jobId,
  ) async {
    try {
      final result = await jobDataSourceDao.getByJobId(jobId);
      return Right(
        result
            .map((entity) => JobDataSourceTranslator.I.toModel(entity)!)
            .toList(),
      );
    } catch (e) {
      return Left(
        DatabaseFailure("Error when fetching data sources "
            "of the job with id = $jobId: $e"),
      );
    }
  }
}
