import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class RefreshingJobsControlState extends ConvertouchState {
  const RefreshingJobsControlState();
}

class RefreshingJobsProgressUpdated extends RefreshingJobsControlState {
  final Map<int, RefreshingJobModel> jobsInProgress;
  final int? completedJobId;

  const RefreshingJobsProgressUpdated({
    required this.jobsInProgress,
    this.completedJobId,
  });

  @override
  List<Object?> get props => [
    jobsInProgress,
    completedJobId,
  ];

  @override
  String toString() {
    return 'RefreshingJobsProgressUpdated{'
        'jobsInProgress: $jobsInProgress, '
        'completedJobId: $completedJobId}';
  }
}

class RefreshingJobsControlNotificationState
    extends ConvertouchNotificationState implements RefreshingJobsControlState {
  const RefreshingJobsControlNotificationState({
    required super.message,
  });

  @override
  String toString() {
    return 'RefreshingJobsControlNotificationState{'
        'message: $message}';
  }
}

class RefreshingJobsControlErrorState extends ConvertouchErrorState
    implements RefreshingJobsControlState {
  const RefreshingJobsControlErrorState({
    required super.exception,
    required super.lastSuccessfulState,
  });

  @override
  String toString() {
    return 'RefreshingJobsControlErrorState{'
        'exception: $exception, '
        'lastSuccessfulState: $lastSuccessfulState}';
  }
}
