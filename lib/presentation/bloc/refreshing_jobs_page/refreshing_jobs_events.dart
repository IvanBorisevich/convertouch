import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class RefreshingJobsEvent extends ConvertouchEvent {
  const RefreshingJobsEvent();
}

abstract class SingleJobEvent extends RefreshingJobsEvent {
  final String unitGroupName;

  const SingleJobEvent({
    required this.unitGroupName,
  });

  @override
  List<Object?> get props => [
        unitGroupName,
      ];
}

class FetchRefreshingJobs extends RefreshingJobsEvent {
  const FetchRefreshingJobs();

  @override
  String toString() {
    return 'FetchRefreshingJobs{}';
  }
}

class FetchRefreshingJob extends SingleJobEvent {
  const FetchRefreshingJob({
    required super.unitGroupName,
  });

  @override
  String toString() {
    return 'FetchRefreshingJob{unitGroupName: $unitGroupName}';
  }
}

class ChangeRefreshingJobCron extends SingleJobEvent {
  final Cron newCron;

  const ChangeRefreshingJobCron({
    required this.newCron,
    required super.unitGroupName,
  });

  @override
  List<Object?> get props => [
        newCron,
        super.props,
      ];

  @override
  String toString() {
    return 'ChangeRefreshingJobCron{'
        'unitGroupName: $unitGroupName, '
        'newCron: $newCron}';
  }
}

class StartRefreshingJobForConversion extends SingleJobEvent {
  const StartRefreshingJobForConversion({
    required super.unitGroupName,
  });

  @override
  List<Object?> get props => [
        unitGroupName,
      ];

  @override
  String toString() {
    return 'StartRefreshingJobForConversion{unitGroupName: $unitGroupName}';
  }
}

class StopRefreshingJobForConversion extends SingleJobEvent {
  const StopRefreshingJobForConversion({
    required super.unitGroupName,
  });

  @override
  List<Object?> get props => [
        unitGroupName,
      ];

  @override
  String toString() {
    return 'StopRefreshingJobForConversion{unitGroupName: $unitGroupName}';
  }
}
