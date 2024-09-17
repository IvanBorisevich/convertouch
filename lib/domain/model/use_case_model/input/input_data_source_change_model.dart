import 'package:convertouch/domain/model/data_source_model.dart';
import 'package:convertouch/domain/model/job_model.dart';

class InputDataSourceChangeModel {
  final JobModel job;
  final DataSourceModel newDataSource;

  const InputDataSourceChangeModel({
    required this.job,
    required this.newDataSource,
  });
}