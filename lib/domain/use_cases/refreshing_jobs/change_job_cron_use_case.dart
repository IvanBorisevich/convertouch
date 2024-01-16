import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_cron_change_model.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class ChangeJobCronUseCase
    extends UseCase<InputCronChangeModel, RefreshingJobModel> {
  final RefreshingJobRepository refreshingJobRepository;

  const ChangeJobCronUseCase({
    required this.refreshingJobRepository,
  });

  @override
  Future<Either<Failure, RefreshingJobModel>> execute(
    InputCronChangeModel input,
  ) async {
    try {
      RefreshingJobModel jobUpdate = RefreshingJobModel.coalesce(
        input.job,
        cron: input.newCron,
      );
      final result = await refreshingJobRepository.update(jobUpdate);

      if (result.isLeft) {
        throw result.left;
      }

      return Right(jobUpdate);
    } catch (e) {
      return Left(
        InternalFailure("Error when toggling auto refresh mode "
            "in job with id = ${input.job.id}: $e"),
      );
    }
  }
}
