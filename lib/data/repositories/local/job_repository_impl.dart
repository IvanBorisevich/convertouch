import 'package:convertouch/data/const/refreshing_jobs.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/repositories/job_repository.dart';
import 'package:either_dart/either.dart';

class JobRepositoryImpl extends JobRepository {
  const JobRepositoryImpl();

  @override
  Future<Either<ConvertouchException, Map<String, JobModel>>> getAll() async {
    try {
      return Right(
        convertouchJobs.map(
          (key, value) => MapEntry(key, JobModel.fromJson(value)!),
        ),
      );
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when getting all jobs",
          stackTrace: null,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
