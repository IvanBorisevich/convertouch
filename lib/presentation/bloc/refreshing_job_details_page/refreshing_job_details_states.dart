import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/bloc/abstract_state.dart';

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
  final bool updated;

  const RefreshingJobDetailsReady({
    required this.job,
    this.updated = false,
  });

  @override
  List<Object?> get props => [
    job,
    updated,
  ];

  @override
  String toString() {
    return 'RefreshingJobDetailsReady{'
        'job: $job, '
        'updated: $updated}';
  }
}

class RefreshingJobDetailsErrorState extends ConvertouchErrorState
    implements RefreshingJobDetailsState {
  const RefreshingJobDetailsErrorState({
    required super.exception,
    required super.lastSuccessfulState,
  });

  @override
  String toString() {
    return 'RefreshingJobDetailsErrorState{'
        'exception: $exception, '
        'lastSuccessfulState: $lastSuccessfulState}';
  }
}
