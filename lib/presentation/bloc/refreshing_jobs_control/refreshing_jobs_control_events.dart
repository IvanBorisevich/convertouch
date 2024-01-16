import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class RefreshingJobsControlEvent extends ConvertouchEvent {
  final RefreshingJobModel job;
  final Map<int, Stream<double>?> jobsProgress;

  const RefreshingJobsControlEvent({
    required this.job,
    this.jobsProgress = const {},
  });

  @override
  List<Object?> get props => [
    job,
    jobsProgress,
  ];
}

class StartJob extends RefreshingJobsControlEvent {
  const StartJob({
    required super.job,
    super.jobsProgress,
  });

  @override
  String toString() {
    return 'StartJob{'
        'job: $job, '
        'jobsProgress: $jobsProgress}';
  }
}

class StopJob extends RefreshingJobsControlEvent {
  const StopJob({
    required super.job,
    super.jobsProgress,
  });

  @override
  String toString() {
    return 'StopJob{'
        'job: $job, '
        'jobsProgress: $jobsProgress}';
  }
}

class FinishJob extends RefreshingJobsControlEvent {
  const FinishJob({
    required super.job,
    super.jobsProgress,
  });

  @override
  String toString() {
    return 'FinishJob{'
        'job: $job, '
        'jobsProgress: $jobsProgress}';
  }
}
