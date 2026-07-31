import 'package:convertouch/domain/model/conversion_param_set_value_model.dart';
import 'package:convertouch/domain/model/job_model.dart';
import 'package:convertouch/domain/model/unit_model.dart';
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

class CreateRefreshingJob extends SingleJobEvent {
  final JobExecutionMode jobExecutionMode;

  const CreateRefreshingJob({
    required super.unitGroupName,
    required super.paramSetName,
    this.jobExecutionMode = JobExecutionMode.continueAlreadyRunningJobIfAny,
    super.onError,
  });

  @override
  List<Object?> get props => [
        super.props,
        jobExecutionMode,
      ];

  @override
  String toString() {
    return 'CreateRefreshingJob{'
        'unitGroupName: $unitGroupName, '
        'paramSetName: $paramSetName, '
        'jobExecutionMode: $jobExecutionMode}';
  }
}

class StartRefreshingJob extends RefreshingJobsEvent {
  final String unitGroupName;
  final ConversionParamSetValueModel params;
  final UnitModel? srcUnitOfRefreshingValue;

  const StartRefreshingJob({
    required this.unitGroupName,
    required this.params,
    this.srcUnitOfRefreshingValue,
    super.onError,
  });

  @override
  List<Object?> get props => [
        unitGroupName,
        params,
        srcUnitOfRefreshingValue,
      ];

  @override
  String toString() {
    return 'StartRefreshingJob{'
        'unitGroupName: $unitGroupName, '
        'params: $params, '
        'srcUnitOfRefreshingValue: $srcUnitOfRefreshingValue}';
  }
}

class StopRefreshingJob extends SingleJobEvent {
  final bool stopOnError;
  final bool forceStop;
  final void Function()? onComplete;

  const StopRefreshingJob({
    required super.unitGroupName,
    required super.paramSetName,
    this.stopOnError = false,
    this.forceStop = false,
    this.onComplete,
  });

  @override
  List<Object?> get props => [
        super.props,
        stopOnError,
        forceStop,
      ];

  @override
  String toString() {
    return 'StopRefreshingJob{'
        'unitGroupName: $unitGroupName, '
        'paramSetName: $paramSetName, '
        'forceStop: $forceStop, '
        'stopOnError: $stopOnError}';
  }
}
