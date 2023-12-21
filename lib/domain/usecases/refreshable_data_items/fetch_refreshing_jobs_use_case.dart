import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class FetchRefreshingJobsUseCase
    extends UseCaseNoInput<RefreshingJobsFetched> {
  final RefreshingJobRepository refreshingJobRepository;

  const FetchRefreshingJobsUseCase({
    required this.refreshingJobRepository,
  });

  @override
  Future<Either<Failure, RefreshingJobsFetched>> execute() async {
    try {
      var result = await refreshingJobRepository.fetchAll();

      if (result.isLeft) {
        throw result.left;
      }

      return Right(
        RefreshingJobsFetched(
          items: result.right,
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error when fetching refreshing jobs: $e"),
      );
    }
  }
}
