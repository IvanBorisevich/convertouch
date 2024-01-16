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
  final Map<int, Stream<double>?> jobsProgress;
  final int? completedJobId;

  const RefreshingJobsProgressUpdated({
    required this.jobsProgress,
    this.completedJobId,
  });

  @override
  List<Object?> get props => [
    jobsProgress,
    completedJobId,
  ];

  @override
  String toString() {
    return 'RefreshingJobsProgressUpdated{'
        'jobsProgress: $jobsProgress, '
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