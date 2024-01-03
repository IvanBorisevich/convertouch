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

abstract class RefreshDataEvent extends RefreshingJobsEvent {
  final RefreshingJobModel job;
  final Map<int, Stream<double>> allJobsDataRefreshingProgress;

  const RefreshDataEvent({
    required this.job,
    this.allJobsDataRefreshingProgress = const {},
  });

  @override
  List<Object?> get props => [
    job,
    allJobsDataRefreshingProgress,
  ];
}

class StartRefreshingData extends RefreshDataEvent {
  const StartRefreshingData({
    required super.job,
    super.allJobsDataRefreshingProgress,
  });

  @override
  String toString() {
    return 'StartRefreshingData{'
        'allJobsDataRefreshingProgress: $allJobsDataRefreshingProgress}';
  }
}

class StopRefreshingData extends RefreshDataEvent {
  const StopRefreshingData({
    required super.job,
    super.allJobsDataRefreshingProgress,
  });

  @override
  String toString() {
    return 'StopRefreshingData{'
        'allJobsDataRefreshingProgress: $allJobsDataRefreshingProgress}';
  }
}
