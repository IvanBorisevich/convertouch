import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class RefreshingJobsState extends ConvertouchState {
  const RefreshingJobsState();
}

class RefreshingJobsFetched extends RefreshingJobsState {
  final Map<String, RefreshingJobModel> jobs;
  final List<String> namesOfRefreshedGroups;

  const RefreshingJobsFetched({
    required this.jobs,
    this.namesOfRefreshedGroups = const [],
  });

  @override
  List<Object?> get props => [
    jobs,
    namesOfRefreshedGroups,
  ];

  @override
  String toString() {
    return 'RefreshingJobsFetched{'
        'items: $jobs, '
        'namesOfRefreshedGroups: $namesOfRefreshedGroups}';
  }
}

class RefreshingJobDetailsOpened extends RefreshingJobsFetched {
  final RefreshingJobModel openedJob;

  const RefreshingJobDetailsOpened({
    required this.openedJob,
    required super.jobs,
    super.namesOfRefreshedGroups,
  });

  @override
  List<Object?> get props => [
    openedJob,
    namesOfRefreshedGroups,
  ];

  @override
  String toString() {
    return 'RefreshingJobDetailsOpened{openedJob: $openedJob}';
  }
}

class RefreshingJobsNotificationState
    extends ConvertouchNotificationState implements RefreshingJobsState {
  const RefreshingJobsNotificationState({
    required super.message,
  });

  @override
  String toString() {
    return 'RefreshingJobsNotificationState{'
        'message: $message}';
  }
}

class RefreshingJobsErrorState extends ConvertouchErrorState
    implements RefreshingJobsState {
  const RefreshingJobsErrorState({
    required super.exception,
    required super.lastSuccessfulState,
  });

  @override
  String toString() {
    return 'RefreshingJobsErrorState{'
        'exception: $exception}';
  }
}
