import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/job_data_source_model.dart';
import 'package:either_dart/either.dart';

abstract class JobDataSourceRepository {
  const JobDataSourceRepository();

  Future<Either<Failure, List<JobDataSourceModel>>> getByJobId(int jobId);
}
