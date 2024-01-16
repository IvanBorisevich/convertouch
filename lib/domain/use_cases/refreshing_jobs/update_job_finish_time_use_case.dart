import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class UpdateJobFinishTimeUseCase extends UseCase<RefreshingJobModel, void> {
  final RefreshingJobRepository refreshingJobRepository;

  const UpdateJobFinishTimeUseCase({
    required this.refreshingJobRepository,
  });

  @override
  Future<Either<Failure, void>> execute(RefreshingJobModel input) async {
    RefreshingJobModel model = RefreshingJobModel.coalesce(
      input,
      lastRefreshTime: DateTime.now().toString(),
    );

    return await refreshingJobRepository.update(model);
  }
}
