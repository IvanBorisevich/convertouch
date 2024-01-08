import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/input/refreshing_job_details_event.dart';
import 'package:convertouch/domain/model/output/refreshing_job_details_states.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/repositories/job_data_source_repository.dart';
import 'package:convertouch/domain/usecases/refreshing_jobs/select_job_data_source_use_case.dart';
import 'package:convertouch/domain/usecases/use_case.dart';
import 'package:either_dart/either.dart';

class GetJobDetailsUseCase
    extends UseCase<OpenJobDetails, RefreshingJobDetailsReady> {
  final SelectJobDataSourceUseCase selectJobDataSourceUseCase;
  final JobDataSourceRepository jobDataSourceRepository;

  const GetJobDetailsUseCase({
    required this.selectJobDataSourceUseCase,
    required this.jobDataSourceRepository,
  });

  @override
  Future<Either<Failure, RefreshingJobDetailsReady>> execute(
    OpenJobDetails input,
  ) async {
    try {
      final dataSourcesResult =
          await jobDataSourceRepository.getByJobId(input.job.id!);

      if (dataSourcesResult.isLeft) {
        throw dataSourcesResult.left;
      }

      RefreshingJobModel? updatedJob;
      if (input.job.selectedDataSource == null &&
          dataSourcesResult.right.isNotEmpty) {
        final selectDataSourceResult = await selectJobDataSourceUseCase.execute(
          SelectDataSource(
            newDataSource: dataSourcesResult.right.first,
            job: input.job,
            progressValue: input.progressValue,
          ),
        );

        if (selectDataSourceResult.isLeft) {
          throw selectDataSourceResult.left;
        }

        updatedJob = selectDataSourceResult.right.job;
      }

      return Right(
        RefreshingJobDetailsReady(
          job: updatedJob ?? input.job,
          progressValue: input.progressValue,
          jobDataSources: dataSourcesResult.right,
        ),
      );
    } catch (e) {
      return Left(
        InternalFailure("Error when fetching refreshing job details: $e"),
      );
    }
  }
}
