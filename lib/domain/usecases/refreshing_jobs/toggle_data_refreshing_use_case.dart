import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/refreshing_jobs_events.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class ToggleDataRefreshingUseCase
    extends UseCase<ToggleDataRefreshing, RefreshingJobsFetched> {
  final RefreshingJobRepository refreshingJobRepository;

  const ToggleDataRefreshingUseCase({
    required this.refreshingJobRepository,
  });

  @override
  Future<Either<Failure, RefreshingJobsFetched>> execute(
    ToggleDataRefreshing input,
  ) async {
    int id = input.job.id!;

    try {
      Map<int, Stream<int>> dataRefreshingProgress = {};

      if (input.dataRefreshingProgress.isNotEmpty) {
        dataRefreshingProgress = input.dataRefreshingProgress;
      }

      final resultOfUpdate = await refreshingJobRepository.update(
        RefreshingJobModel(
          id: id,
          name: input.job.name,
          unitGroup: input.job.unitGroup,
          refreshableDataPart: input.job.refreshableDataPart,
          dataRefreshingStatus: dataRefreshingProgress.containsKey(id)
              ? DataRefreshingStatus.off
              : DataRefreshingStatus.on,
        ),
      );

      if (resultOfUpdate.isLeft) {
        throw resultOfUpdate.left;
      }

      if (!dataRefreshingProgress.containsKey(id)) {
        final stream =
            Stream.periodic(const Duration(seconds: 1), (i) => i * 10).take(10);

        dataRefreshingProgress.putIfAbsent(id, () => stream);
      } else {
        dataRefreshingProgress.remove(id);
      }

      final resultOfFetch = await refreshingJobRepository.fetchAll();

      if (resultOfFetch.isLeft) {
        throw resultOfFetch.left;
      }

      return Right(
        RefreshingJobsFetched(
          items: resultOfFetch.right,
          dataRefreshingProgress: dataRefreshingProgress,
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error when toggling refreshing job with id = $id: $e"),
      );
    }
  }
}
