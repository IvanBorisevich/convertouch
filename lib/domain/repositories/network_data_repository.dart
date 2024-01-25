import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/failure.dart';
import 'package:convertouch/domain/model/job_data_source_model.dart';
import 'package:either_dart/either.dart';

abstract class NetworkDataRepository {
  const NetworkDataRepository();

  Future<Either<Failure, List<T>>> refreshForGroup<T>({
    required int unitGroupId,
    required JobDataSourceModel dataSource,
    required RefreshableDataPart refreshableDataPart,
  });
}
