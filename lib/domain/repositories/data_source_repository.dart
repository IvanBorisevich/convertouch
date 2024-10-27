import 'package:convertouch/domain/model/data_source_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:either_dart/either.dart';

abstract class DataSourceRepository {
  const DataSourceRepository();

  Future<Either<ConvertouchException, DataSourceModel>> get({
    required String unitGroupName,
    String? dataSourceName,
  });
}
