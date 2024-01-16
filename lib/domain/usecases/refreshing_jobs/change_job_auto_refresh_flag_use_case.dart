import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/usecases/input/input_auto_refresh_flag_change_model.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class ChangeJobAutoRefreshFlagUseCase
    extends UseCase<InputAutoRefreshFlagChangeModel, RefreshingJobModel> {
  final RefreshingJobRepository refreshingJobRepository;

  const ChangeJobAutoRefreshFlagUseCase({
    required this.refreshingJobRepository,
  });

  @override
  Future<Either<Failure, RefreshingJobModel>> execute(
    InputAutoRefreshFlagChangeModel input,
  ) async {
    try {
      RefreshingJobModel jobUpdate = RefreshingJobModel.coalesce(
        input.job,
        autoRefresh: input.newFlag,
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
