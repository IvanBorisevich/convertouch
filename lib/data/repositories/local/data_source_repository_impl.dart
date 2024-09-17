import 'package:convertouch/data/const/data_sources.dart';
import 'package:convertouch/data/translators/data_source_translator.dart';
import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/data_source_model.dart';
import 'package:convertouch/domain/model/exception_model.dart';
import 'package:convertouch/domain/repositories/data_source_repository.dart';
import 'package:either_dart/either.dart';

class DataSourceRepositoryImpl extends DataSourceRepository {
  const DataSourceRepositoryImpl();

  @override
  Future<Either<ConvertouchException, Map<String, String>>>
      getAllSelected() async {
    try {
      return Right(
        convertouchDataSources.map(
          (key, value) => MapEntry(
            key,
            (value["selectedDataSource"] ?? "default") as String,
          ),
        ),
      );
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when getting all selected data sources",
          stackTrace: null,
          dateTime: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<Either<ConvertouchException, DataSourceModel>> getSelected(
    String unitGroupName,
  ) async {
    try {
      Map<String, dynamic> dataSourcesInfo =
          convertouchDataSources[unitGroupName]!;
      Map<String, dynamic> dataSourcesMap = dataSourcesInfo["dataSources"]!;
      String? selectedDataSourceName = dataSourcesInfo["selectedDataSource"];
      RefreshableDataPart refreshablePart = dataSourcesInfo["refreshablePart"];
      Map<String, dynamic> selectedDataSourceMap =
          dataSourcesMap[selectedDataSourceName ?? "default"];
      selectedDataSourceMap.putIfAbsent(
        "refreshablePart",
        () => refreshablePart,
      );

      return Right(
        DataSourceTranslator.I.toModel(selectedDataSourceMap)!,
      );
    } catch (e) {
      return Left(
        InternalException(
          message: "Error when getting selected data source of the group "
              "$unitGroupName",
          stackTrace: null,
          dateTime: DateTime.now(),
        ),
      );
    }
  }
}
