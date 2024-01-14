import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/output/refreshing_jobs_states.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/repositories/network_data_repository.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class RefreshUnitCoefficientsUseCase
    extends ReactiveUseCase<RefreshingJobModel, RefreshingJobsProgressUpdated> {
  final NetworkDataRepository networkDataRepository;

  const RefreshUnitCoefficientsUseCase({
    required this.networkDataRepository,
  });

  @override
  Either<Failure, Stream<RefreshingJobsProgressUpdated>> execute(
    RefreshingJobModel input,
  ) {
    if (input.selectedDataSource == null) {
      throw Exception("No data source found for the job id = ${input.id}");
    }

    final fetchResult =
        networkDataRepository.fetch(input.selectedDataSource!.url);

    if (fetchResult.isLeft) {
      return Left(fetchResult.left);
    }

    return Right(
      Stream.value(
        const RefreshingJobsProgressUpdated(
          progressValues: {},
        ),
      ),
    );
  }
}
