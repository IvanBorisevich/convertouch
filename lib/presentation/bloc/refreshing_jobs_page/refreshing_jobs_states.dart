import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

abstract class RefreshingJobsState extends ConvertouchState {
  const RefreshingJobsState();
}

class RefreshingJobsFetched extends RefreshingJobsState {
  final Map<String, RefreshingJobModel> jobs;
  final OutputConversionModel? rebuiltConversion;

  const RefreshingJobsFetched({
    required this.jobs,
    this.rebuiltConversion,
  });

  @override
  List<Object?> get props => [
    jobs.entries,
    rebuiltConversion,
  ];

  @override
  String toString() {
    return 'RefreshingJobsFetched{'
        'items: $jobs, '
        'rebuiltConversion: $rebuiltConversion}';
  }
}

class RefreshingJobDetailsOpened extends RefreshingJobsFetched {
  final RefreshingJobModel openedJob;

  const RefreshingJobDetailsOpened({
    required this.openedJob,
    required super.jobs,
  });

  @override
  List<Object?> get props => [
    openedJob,
    super.props,
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
