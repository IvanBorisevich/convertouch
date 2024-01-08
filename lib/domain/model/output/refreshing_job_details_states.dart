import 'package:convertouch/domain/model/output/abstract_state.dart';
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
  final Stream<double>? progressValue;

  const RefreshingJobDetailsReady({
    required this.job,
    required this.progressValue,
  });

  @override
  List<Object?> get props => [
    job,
    progressValue,
  ];

  @override
  String toString() {
    return 'RefreshingJobDetailsReady{job: $job}';
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