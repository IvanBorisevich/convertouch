import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/repositories/job_data_source_repository.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/change_job_data_source_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetJobDetailsUseCase
    extends UseCase<RefreshingJobModel, RefreshingJobModel> {
  final ChangeJobDataSourceUseCase changeJobDataSourceUseCase;
  final JobDataSourceRepository jobDataSourceRepository;

  const GetJobDetailsUseCase({
    required this.changeJobDataSourceUseCase,
    required this.jobDataSourceRepository,
  });

  @override
  Future<Either<ConvertouchException, RefreshingJobModel>> execute(
    RefreshingJobModel input,
  ) async {
    try {
      if (input.dataSources.isEmpty) {
        final dataSourcesResult =
            await jobDataSourceRepository.getByJobId(input.id!);

        if (dataSourcesResult.isLeft) {
          throw dataSourcesResult.left;
        }

        return Right(
          RefreshingJobModel.coalesce(
            input,
            dataSources: dataSourcesResult.right,
          ),
        );
      }

      return Right(input);
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when fetching refreshing job details: $e",
        ),
      );
    }
  }
}
