import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_job_stop_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:convertouch/domain/utils/object_utils.dart';
import 'package:either_dart/either.dart';

class StopJobUseCase<R> extends UseCase<InputJobStopModel, JobModel> {
  const StopJobUseCase();

  @override
  Future<Either<ConvertouchException, JobModel>> execute(
    InputJobStopModel input,
  ) async {
    try {
      input.job.progressController?.close();

      JobModel stoppedJob = input.job.copyWith(
        progressController: const Patchable(null, patchNull: true),
        completedAt: Patchable(
          input.stopOnError || input.forceStop ? null : DateTime.now(),
          patchNull: false,
        ),
      );

      return Right(stoppedJob);
    } catch (e, stackTrace) {
      return Left(
        ConvertouchException(
          message: "Error when stopping the refreshing job '${input.job.name}'",
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
