import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/refreshing_jobs_events.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class RefreshDataUseCase
    extends UseCase<StartDataRefreshing, RefreshingJobsProgressUpdated> {
  const RefreshDataUseCase();

  @override
  Future<Either<Failure, RefreshingJobsProgressUpdated>> execute(
    StartDataRefreshing input,
  ) async {
    int jobId = input.job.id!;
    try {
      return const Right(
        RefreshingJobsProgressUpdated(progressValues: {}),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error when refreshing data by job"
            " with id = $jobId: $e"),
      );
    }
  }
}
