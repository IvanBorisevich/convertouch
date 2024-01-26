import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetJobsListUseCase extends UseCaseNoInput<List<RefreshingJobModel>> {
  final RefreshingJobRepository refreshingJobRepository;

  const GetJobsListUseCase({
    required this.refreshingJobRepository,
  });

  @override
  Future<Either<ConvertouchException, List<RefreshingJobModel>>>
      execute() async {
    try {
      return await refreshingJobRepository.getAll();
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when fetching refreshing jobs: $e",
        ),
      );
    }
  }
}
