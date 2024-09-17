import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:either_dart/either.dart';

abstract class JobRepository {
  const JobRepository();

  Future<Either<ConvertouchException, Map<String, JobModel>>> getAll();
}
