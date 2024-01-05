import 'package:convertouch/domain/model/failure.dart';
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
  final Map<int, Stream<double>?> progressValues;

  const RefreshDataEvent({
    required this.job,
    this.progressValues = const {},
  });

  @override
  List<Object?> get props => [
    job,
    progressValues,
  ];
}

class StartDataRefreshing extends RefreshDataEvent {
  const StartDataRefreshing({
    required super.job,
    super.progressValues,
  });

  @override
  String toString() {
    return 'StartDataRefreshing{'
        'job: $job, '
        'progressValues: $progressValues}';
  }
}

class StopDataRefreshing extends RefreshDataEvent {
  const StopDataRefreshing({
    required super.job,
    super.progressValues,
  });

  @override
  String toString() {
    return 'StopDataRefreshing{'
        'job: $job, '
        'progressValues: $progressValues}';
  }
}

class CompleteDataRefreshing extends RefreshDataEvent {
  const CompleteDataRefreshing({
    required super.job,
    super.progressValues,
  });

  @override
  String toString() {
    return 'CompleteDataRefreshing{'
        'job: $job, '
        'progressValues: $progressValues}';
  }
}

class FailDataRefreshing extends RefreshDataEvent {
  final Failure failure;

  const FailDataRefreshing({
    required super.job,
    super.progressValues,
    required this.failure,
  });

  @override
  String toString() {
    return 'CompleteDataRefreshing{'
        'job: $job, '
        'progressValues: $progressValues,'
        'failure: $failure}';
  }
}
