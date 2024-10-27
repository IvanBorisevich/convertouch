import 'package:convertouch/data/const/data_sources.dart';
import 'package:convertouch/domain/model/data_source_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/data_source_repository.dart';
import 'package:either_dart/either.dart';

class DataSourceRepositoryImpl extends DataSourceRepository {
  const DataSourceRepositoryImpl();

  @override
  Future<Either<ConvertouchException, DataSourceModel>> get({
    required String unitGroupName,
    String? dataSourceName,
  }) async {
    try {
      String dataSourceKey = dataSourceName ?? defaultDataSourceName;
      Map<String, DataSourceModel>? dataSources =
          convertouchDataSources[unitGroupName];

      DataSourceModel? result =
          dataSources != null ? dataSources[dataSourceKey] : null;

      if (result == null) {
        return Left(
          DatabaseException(
            message: "Data source '$dataSourceKey' "
                "of the group '$unitGroupName' not found",
            stackTrace: null,
            dateTime: DateTime.now(),
          ),
        );
      }

      return Right(result);
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when getting selected data source of the group "
              "$unitGroupName: $e",
          stackTrace: null,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
