import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/network_data_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class RefreshingJobsEvent extends ConvertouchEvent {
  const RefreshingJobsEvent({
    super.onSuccess,
    super.onError,
  });
}

abstract class SingleJobEvent extends RefreshingJobsEvent {
  final String unitGroupName;

  const SingleJobEvent({
    required this.unitGroupName,
    super.onSuccess,
    super.onError,
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

class ChangeJobInfo extends SingleJobEvent {
  final JobModel jobPatch;
  final bool forceReplaceWithNulls;

  const ChangeJobInfo({
    required this.jobPatch,
    this.forceReplaceWithNulls = false,
    required super.unitGroupName,
  });

  @override
  List<Object?> get props => [
        jobPatch,
        forceReplaceWithNulls,
        super.props,
      ];

  @override
  String toString() {
    return 'ChangeJobInfo{'
        'jobPatch: $jobPatch, '
        'unitGroupName: $unitGroupName}';
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
  final void Function(NetworkDataModel)? onFetchSuccess;

  const StartRefreshingJobForConversion({
    required super.unitGroupName,
    this.onFetchSuccess,
    super.onSuccess,
    super.onError,
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
    super.onError,
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
