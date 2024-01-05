import 'package:convertouch/domain/model/output/abstract_state.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';

abstract class RefreshingJobsState extends ConvertouchState {
  const RefreshingJobsState();
}

class RefreshingJobsFetching extends RefreshingJobsState {
  const RefreshingJobsFetching();

  @override
  String toString() {
    return 'RefreshingJobsFetching{}';
  }
}

class RefreshingJobsFetched extends RefreshingJobsState {
  final List<RefreshingJobModel> items;
  final Map<int, Stream<double>> allJobsDataRefreshingProgress;

  const RefreshingJobsFetched({
    required this.items,
    this.allJobsDataRefreshingProgress = const {},
  });

  @override
  List<Object?> get props => [
    items,
    allJobsDataRefreshingProgress,
  ];

  @override
  String toString() {
    return 'RefreshingJobsFetched{'
        'items: $items, '
        'allJobsDataRefreshingProgress: $allJobsDataRefreshingProgress}';
  }
}

class RefreshingJobsProgressUpdating extends RefreshingJobsState {
  const RefreshingJobsProgressUpdating();

  @override
  String toString() {
    return 'RefreshingJobsProgressUpdating{}';
  }
}

class RefreshingJobsProgressUpdated extends RefreshingJobsState {
  final Map<int, Stream<double>?> progressValues;
  final int? completedJobId;

  const RefreshingJobsProgressUpdated({
    required this.progressValues,
    this.completedJobId,
  });

  @override
  List<Object?> get props => [
    progressValues,
    completedJobId,
  ];

  @override
  String toString() {
    return 'RefreshingJobsProgressUpdated{'
        'progressValues: $progressValues, '
        'completedJobId: $completedJobId}';
  }
}

class RefreshingJobsErrorState extends RefreshingJobsState {
  final String message;

  const RefreshingJobsErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'RefreshingJobsErrorState{message: $message}';
  }
}