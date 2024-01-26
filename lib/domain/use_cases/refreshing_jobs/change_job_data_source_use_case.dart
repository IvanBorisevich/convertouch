import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/input/input_data_source_change_model.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class ChangeJobDataSourceUseCase
    extends UseCase<InputDataSourceChangeModel, RefreshingJobModel> {
  final RefreshingJobRepository refreshingJobRepository;

  const ChangeJobDataSourceUseCase({
    required this.refreshingJobRepository,
  });

  @override
  Future<Either<ConvertouchException, RefreshingJobModel>> execute(
    InputDataSourceChangeModel input,
  ) async {
    try {
      RefreshingJobModel jobUpdate = RefreshingJobModel.coalesce(
        input.job,
        selectedDataSource: input.newDataSource,
      );
      final result = await refreshingJobRepository.update(jobUpdate);

      if (result.isLeft) {
        throw result.left;
      }

      return Right(jobUpdate);
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when toggling auto refresh mode "
              "in job '${input.job.name}': $e",
        ),
      );
    }
  }
}
