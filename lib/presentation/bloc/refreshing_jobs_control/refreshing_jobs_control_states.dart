import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class RefreshingJobsControlState extends ConvertouchState {
  const RefreshingJobsControlState();
}

class RefreshingJobsProgressUpdating extends RefreshingJobsControlState {
  const RefreshingJobsProgressUpdating();

  @override
  String toString() {
    return 'RefreshingJobsProgressUpdating{}';
  }
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

class RefreshingJobsControlErrorState extends RefreshingJobsControlState {
  final String message;

  const RefreshingJobsControlErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'RefreshingJobsControlErrorState{message: $message}';
  }
}