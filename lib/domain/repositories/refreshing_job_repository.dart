import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:either_dart/either.dart';

abstract class RefreshingJobRepository {
  const RefreshingJobRepository();

  Future<Either<Failure, List<RefreshingJobModel>>> getAll();

  Future<Either<Failure, RefreshingJobModel?>> get(int id);

  Future<Either<Failure, RefreshingJobModel?>> getByGroupId(int unitGroupId);

  Future<Either<Failure, void>> update(RefreshingJobModel model);
}
