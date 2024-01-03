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

abstract class SingleJobEvent extends RefreshingJobsEvent {
  final RefreshingJobModel job;

  const SingleJobEvent({
    required this.job,
  });

  @override
  List<Object?> get props => [
        job,
      ];
}

class ToggleDataRefreshing extends SingleJobEvent {
  final Map<int, Stream<int>> dataRefreshingProgress;

  const ToggleDataRefreshing({
    required super.job,
    this.dataRefreshingProgress = const {},
  });

  @override
  List<Object?> get props => [
    job,
    dataRefreshingProgress,
  ];

  @override
  String toString() {
    return 'ToggleDataRefreshing{'
        'dataRefreshingProgress: $dataRefreshingProgress}';
  }
}
