import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/refreshing_jobs_events.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class StartRefreshingDataUseCase
    extends UseCase<StartRefreshingData, RefreshingJobsFetched> {
  final RefreshingJobRepository refreshingJobRepository;

  const StartRefreshingDataUseCase({
    required this.refreshingJobRepository,
  });

  @override
  Future<Either<Failure, RefreshingJobsFetched>> execute(
    StartRefreshingData input,
  ) async {
    int id = input.job.id!;

    try {
      Map<int, Stream<double>> allJobsDataRefreshingProgress = {};

      if (input.allJobsDataRefreshingProgress.isNotEmpty) {
        allJobsDataRefreshingProgress = input.allJobsDataRefreshingProgress;
      }

      if (!allJobsDataRefreshingProgress.containsKey(id)) {
        Stream<double> stream =
            Stream.periodic(const Duration(seconds: 1), (i) => (i + 1) * 0.1)
                .take(10);

        allJobsDataRefreshingProgress.putIfAbsent(id, () => stream);
      } else {
        allJobsDataRefreshingProgress.remove(id);
      }

      final resultOfFetch = await refreshingJobRepository.fetchAll();

      if (resultOfFetch.isLeft) {
        throw resultOfFetch.left;
      }

      return Right(
        RefreshingJobsFetched(
          items: resultOfFetch.right,
          allJobsDataRefreshingProgress: allJobsDataRefreshingProgress,
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error when toggling refreshing job with id = $id: $e"),
      );
    }
  }
}
