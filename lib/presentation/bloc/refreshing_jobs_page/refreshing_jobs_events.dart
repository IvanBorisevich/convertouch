import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/dynamic_data_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class RefreshingJobsEvent extends ConvertouchEvent {
  const RefreshingJobsEvent({
    super.onSuccess,
    super.onError,
  });
}

abstract class SingleJobEvent extends RefreshingJobsEvent {
  final String unitGroupName;
  final String paramSetName;

  const SingleJobEvent({
    required this.unitGroupName,
    required this.paramSetName,
    super.onSuccess,
    super.onError,
  });

  @override
  List<Object?> get props => [
        unitGroupName,
        paramSetName,
      ];
}

class FetchRefreshingJobs extends RefreshingJobsEvent {
  const FetchRefreshingJobs();

  @override
  String toString() {
    return 'FetchRefreshingJobs{}';
  }
}

class ChangeJobInfo extends SingleJobEvent {
  final JobModel jobPatch;
  final bool forceReplaceWithNulls;

  const ChangeJobInfo({
    required this.jobPatch,
    this.forceReplaceWithNulls = false,
    required super.unitGroupName,
    required super.paramSetName,
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
        'unitGroupName: $unitGroupName, '
        'paramSetName: $paramSetName}';
  }
}

class ChangeRefreshingJobCron extends SingleJobEvent {
  final Cron newCron;

  const ChangeRefreshingJobCron({
    required this.newCron,
    required super.unitGroupName,
    required super.paramSetName,
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
        'paramsSetName: $paramSetName, '
        'newCron: $newCron}';
  }
}

class StartRefreshingJobForConversion extends RefreshingJobsEvent {
  final String unitGroupName;
  final ConversionParamSetValueModel params;
  final void Function(DynamicDataModel)? onFetchSuccess;

  const StartRefreshingJobForConversion({
    required this.unitGroupName,
    required this.params,
    this.onFetchSuccess,
    super.onSuccess,
    super.onError,
  });

  @override
  List<Object?> get props => [
        unitGroupName,
        params,
      ];

  @override
  String toString() {
    return 'StartRefreshingJobForConversion{'
        'unitGroupName: $unitGroupName, '
        'params: $params}';
  }
}

class StopRefreshingJobForConversion extends SingleJobEvent {
  const StopRefreshingJobForConversion({
    required super.unitGroupName,
    required super.paramSetName,
    super.onError,
  });

  @override
  String toString() {
    return 'StopRefreshingJobForConversion{'
        'unitGroupName: $unitGroupName, '
        'paramSetName: $paramSetName}';
  }
}
