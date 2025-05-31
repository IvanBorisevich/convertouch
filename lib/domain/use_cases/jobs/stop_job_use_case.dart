import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class StopJobUseCase<R> extends UseCase<JobModel, JobModel> {
  const StopJobUseCase();

  @override
  Future<Either<ConvertouchException, JobModel>> execute(
    JobModel input,
  ) async {
    try {
      input.progressController?.close();

      JobModel stoppedJob = input.copyWith(
        progressController: null,
      );

      return Right(stoppedJob);
    } catch (e, stackTrace) {
      return Left(
        InternalException(
          message: "Error when stopping the refreshing job '${input.name}'",
          stackTrace: stackTrace,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
