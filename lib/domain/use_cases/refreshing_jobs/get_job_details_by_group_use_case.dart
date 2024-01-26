import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/unit_group_model.dart';
import 'package:convertouch/domain/repositories/refreshing_job_repository.dart';
import 'package:convertouch/domain/use_cases/use_case.dart';
import 'package:either_dart/either.dart';

class GetJobDetailsByGroupUseCase
    extends UseCase<UnitGroupModel?, RefreshingJobModel?> {
  final RefreshingJobRepository refreshingJobRepository;

  const GetJobDetailsByGroupUseCase({
    required this.refreshingJobRepository,
  });

  @override
  Future<Either<ConvertouchException, RefreshingJobModel?>> execute(
    UnitGroupModel? input,
  ) async {
    if (input == null) {
      return const Right(null);
    }

    return await refreshingJobRepository.getByGroupId(input.id!);
  }
}
