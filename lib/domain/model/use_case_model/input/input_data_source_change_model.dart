import 'package:convertouch/domain/model/job_data_source_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';

class InputDataSourceChangeModel {
  final RefreshingJobModel job;
  final JobDataSourceModel newDataSource;

  const InputDataSourceChangeModel({
    required this.job,
    required this.newDataSource,
  });
}