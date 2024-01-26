import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:either_dart/either.dart';

abstract class RefreshingJobRepository {
  const RefreshingJobRepository();

  Future<Either<ConvertouchException, List<RefreshingJobModel>>> getAll();

  Future<Either<ConvertouchException, RefreshingJobModel?>> get(int id);

  Future<Either<ConvertouchException, RefreshingJobModel?>> getByGroupId(int unitGroupId);

  Future<Either<ConvertouchException, void>> update(RefreshingJobModel model);
}
