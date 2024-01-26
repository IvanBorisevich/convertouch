import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_data_source_change_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_job_details_model.dart';
import 'package:convertouch/domain/repositories/job_data_source_repository.dart';
import 'package:convertouch/domain/use_cases/refreshing_jobs/change_job_data_source_use_case.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetJobDetailsUseCase
    extends UseCase<RefreshingJobModel, OutputJobDetailsModel> {
  final ChangeJobDataSourceUseCase changeJobDataSourceUseCase;
  final JobDataSourceRepository jobDataSourceRepository;

  const GetJobDetailsUseCase({
    required this.changeJobDataSourceUseCase,
    required this.jobDataSourceRepository,
  });

  @override
  Future<Either<ConvertouchException, OutputJobDetailsModel>> execute(
    RefreshingJobModel input,
  ) async {
    try {
      final dataSourcesResult =
          await jobDataSourceRepository.getByJobId(input.id!);

      if (dataSourcesResult.isLeft) {
        throw dataSourcesResult.left;
      }

      RefreshingJobModel? updatedJob;
      if (input.selectedDataSource == null &&
          dataSourcesResult.right.isNotEmpty) {
        final changeDataSourceResult = await changeJobDataSourceUseCase.execute(
          InputDataSourceChangeModel(
            job: input,
            newDataSource: dataSourcesResult.right.first,
          ),
        );

        if (changeDataSourceResult.isLeft) {
          throw changeDataSourceResult.left;
        }

        updatedJob = changeDataSourceResult.right;
      }

      return Right(
        OutputJobDetailsModel(
          job: updatedJob ?? input,
          dataSources: dataSourcesResult.right,
        ),
      );
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when fetching refreshing job details: $e",
        ),
      );
    }
  }
}
