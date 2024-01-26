import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/model/job_data_source_model.dart';
import 'package:either_dart/either.dart';

abstract class JobDataSourceRepository {
  const JobDataSourceRepository();

  Future<Either<ConvertouchException, List<JobDataSourceModel>>> getByJobId(int jobId);
}
