import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:either_dart/either.dart';

abstract class RefreshingJobRepository {
  const RefreshingJobRepository();

  Future<Either<Failure, List<RefreshingJobModel>>> fetchAll();

  Future<Either<Failure, RefreshingJobModel>> fetch(int id);

  Future<Either<Failure, void>> update(RefreshingJobModel model);

  Future<Either<Failure, void>> updatePatch(
    RefreshingJobModel model, {
    bool patchWithNulls = false,
  });
}
