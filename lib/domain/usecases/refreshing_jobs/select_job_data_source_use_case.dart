import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/refreshing_job_details_event.dart';
import 'package:convertouch/domain/model/output/refreshing_job_details_states.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class SelectJobDataSourceUseCase
    extends UseCase<SelectDataSource, RefreshingJobDetailsReady> {
  final RefreshingJobRepository refreshingJobRepository;

  const SelectJobDataSourceUseCase({
    required this.refreshingJobRepository,
  });

  @override
  Future<Either<Failure, RefreshingJobDetailsReady>> execute(
    SelectDataSource input,
  ) async {
    try {
      RefreshingJobModel jobUpdate = RefreshingJobModel.coalesce(
        input.job,
        selectedDataSource: input.newDataSource,
      );
      final result = await refreshingJobRepository.update(jobUpdate);

      if (result.isLeft) {
        throw result.left;
      }

      return Right(
        RefreshingJobDetailsReady(
          job: jobUpdate,
          progressValue: input.progressValue,
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error when toggling auto refresh mode "
            "in job with id = ${input.job.id}: $e"),
      );
    }
  }
}
