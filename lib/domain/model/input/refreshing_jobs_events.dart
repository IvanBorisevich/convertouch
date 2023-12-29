import 'package:convertouch/domain/model/input/abstract_event.dart';

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
  final int jobId;
  final List<int> activeJobIds;

  const SingleJobEvent({
    required this.jobId,
    this.activeJobIds = const [],
  });

  @override
  List<Object?> get props => [
    jobId,
    activeJobIds,
  ];
}

class ToggleRefreshingJob extends SingleJobEvent {
  const ToggleRefreshingJob({
    required super.jobId,
    super.activeJobIds,
  });

  @override
  String toString() {
    return 'ToggleRefreshingJob{jobId: $jobId}';
  }
}

class StartRefreshingData extends SingleJobEvent {
  const StartRefreshingData({
    required super.jobId,
    super.activeJobIds,
  });

  @override
  String toString() {
    return 'StartRefreshingData{jobId: $jobId}';
  }
}