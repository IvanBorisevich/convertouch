import 'package:convertouch/domain/model/input/abstract_event.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';

abstract class RefreshingJobsEvent extends ConvertouchEvent {
  const RefreshingJobsEvent();
}

class FetchRefreshingJobs extends RefreshingJobsEvent {
  const FetchRefreshingJobs();

  @override
  String toString() {
    return 'FetchRefreshingJobs{}';
  }
}

class RefreshData extends RefreshingJobsEvent {
  final RefreshingJobModel job;
  final Map<int, Stream<double>?> progressValues;

  const RefreshData({
    required this.job,
    this.progressValues = const {},
  });

  @override
  List<Object?> get props => [
    job,
    progressValues,
  ];

  @override
  String toString() {
    return 'RefreshData{'
        'job: $job, '
        'progressValues: $progressValues}';
  }
}
