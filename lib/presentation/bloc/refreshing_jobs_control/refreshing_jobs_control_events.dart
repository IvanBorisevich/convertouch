import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class RefreshingJobsControlEvent extends ConvertouchEvent {
  final RefreshingJobModel job;
  final Map<int, RefreshingJobModel> jobsInProgress;

  const RefreshingJobsControlEvent({
    required this.job,
    this.jobsInProgress = const {},
  });

  @override
  List<Object?> get props => [
    job,
    jobsInProgress,
  ];
}

class ExecuteJob extends RefreshingJobsControlEvent {
  final OutputConversionModel? conversionToBeRebuilt;

  const ExecuteJob({
    required super.job,
    this.conversionToBeRebuilt,
    super.jobsInProgress,
  });

  @override
  String toString() {
    return 'ExecuteJob{'
        'job: $job, '
        'jobsInProgress: $jobsInProgress}';
  }
}

class StopJob extends RefreshingJobsControlEvent {
  const StopJob({
    required super.job,
    super.jobsInProgress,
  });

  @override
  String toString() {
    return 'StopJob{'
        'job: $job, '
        'jobsProgress: $jobsInProgress}';
  }
}

class FinishJob extends RefreshingJobsControlEvent {
  const FinishJob({
    required super.job,
    super.jobsInProgress,
  });

  @override
  String toString() {
    return 'FinishJob{'
        'job: $job, '
        'jobsInProgress: $jobsInProgress}';
  }
}
