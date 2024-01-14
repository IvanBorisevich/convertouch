import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class RefreshUnitValuesUseCase
    extends ReactiveUseCase<RefreshingJobModel, RefreshingJobsProgressUpdated> {
  const RefreshUnitValuesUseCase();

  @override
  Either<Failure, Stream<RefreshingJobsProgressUpdated>> execute(
    RefreshingJobModel input,
  ) {
    return Right(
      Stream.value(
        const RefreshingJobsProgressUpdated(
          progressValues: {},
        ),
      ),
    );
  }
}
