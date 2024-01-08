import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/refreshing_job_details_event.dart';
import 'package:convertouch/domain/model/output/refreshing_job_details_states.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class GetJobDetailsUseCase
    extends UseCase<OpenJobDetails, RefreshingJobDetailsReady> {
  const GetJobDetailsUseCase();

  @override
  Future<Either<Failure, RefreshingJobDetailsReady>> execute(
    OpenJobDetails input,
  ) async {
    try {
      return Right(
        RefreshingJobDetailsReady(
          job: input.job,
          progressValue: input.progressValue,
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error when fetching refreshing job details: $e"),
      );
    }
  }
}
