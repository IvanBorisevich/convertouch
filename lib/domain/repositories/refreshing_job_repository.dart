import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:either_dart/either.dart';

abstract class RefreshingJobRepository {
  const RefreshingJobRepository();

  Future<Either<Failure, List<RefreshingJobModel>>> fetchAll();
}