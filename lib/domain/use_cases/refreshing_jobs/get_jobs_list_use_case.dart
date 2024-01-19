import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetJobsListUseCase
    extends UseCaseNoInput<List<RefreshingJobModel>> {
  final RefreshingJobRepository refreshingJobRepository;

  const GetJobsListUseCase({
    required this.refreshingJobRepository,
  });

  @override
  Future<Either<Failure, List<RefreshingJobModel>>> execute() async {
    try {
      return await refreshingJobRepository.getAll();
    } catch (e) {
      return Left(
        InternalFailure("Error when fetching refreshing jobs: $e"),
      );
    }
  }
}
