import 'package:convertouch/domain/model/job_data_source_model.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';

class OutputJobDetailsModel {
  final RefreshingJobModel job;
  final List<JobDataSourceModel> dataSources;

  const OutputJobDetailsModel({
    required this.job,
    required this.dataSources,
  });
}