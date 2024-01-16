import 'package:convertouch/domain/model/job_data_source_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';

abstract class RefreshingJobDetailsState extends ConvertouchState {
  const RefreshingJobDetailsState();
}

class RefreshingJobDetailsInitialState extends RefreshingJobDetailsState {
  const RefreshingJobDetailsInitialState();

  @override
  String toString() {
    return 'RefreshingJobDetailsInitialState{}';
  }
}

class RefreshingJobDetailsInProgress extends RefreshingJobDetailsState {
  const RefreshingJobDetailsInProgress();

  @override
  String toString() {
    return 'RefreshingJobDetailsInProgress{}';
  }
}

class RefreshingJobDetailsReady extends RefreshingJobDetailsState {
  final RefreshingJobModel job;
  final List<JobDataSourceModel> jobDataSources;

  const RefreshingJobDetailsReady({
    required this.job,
    this.jobDataSources = const [],
  });

  @override
  List<Object?> get props => [
    job,
    jobDataSources,
  ];

  @override
  String toString() {
    return 'RefreshingJobDetailsReady{'
        'job: $job, '
        'jobDataSources: $jobDataSources}';
  }
}

class RefreshingJobDetailsErrorState extends RefreshingJobDetailsState {
  final String message;

  const RefreshingJobDetailsErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'RefreshingJobDetailsErrorState{message: $message}';
  }
}