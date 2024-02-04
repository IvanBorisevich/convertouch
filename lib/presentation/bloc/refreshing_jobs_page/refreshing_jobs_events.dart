import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/use_case_model/output/output_conversion_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

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

class OpenJobDetails extends SingleJobEvent {
  const OpenJobDetails({
    required super.unitGroupName,
  });

  @override
  String toString() {
    return 'OpenJobDetails{unitGroupName: $unitGroupName}';
  }
}

class ChangeJobCron extends SingleJobEvent {
  final Cron newCron;

  const ChangeJobCron({
    required super.unitGroupName,
    required this.newCron,
  });

  @override
  List<Object?> get props => [
        newCron,
        super.props,
      ];

  @override
  String toString() {
    return 'ChangeJobCron{'
        'unitGroupName: $unitGroupName, '
        'newCron: $newCron}';
  }
}

class ExecuteJob extends SingleJobEvent {
  final OutputConversionModel? conversionToBeRebuilt;

  const ExecuteJob({
    required super.unitGroupName,
    this.conversionToBeRebuilt,
  });

  @override
  List<Object?> get props => [
        conversionToBeRebuilt,
        super.props,
      ];

  @override
  String toString() {
    return 'ExecuteJob{'
        'unitGroupName: $unitGroupName}';
  }
}

class StopJob extends SingleJobEvent {
  const StopJob({
    required super.unitGroupName,
  });

  @override
  String toString() {
    return 'StopJob{'
        'unitGroupName: $unitGroupName}';
  }
}

class FinishJob extends SingleJobEvent {
  const FinishJob({
    required super.unitGroupName,
  });

  @override
  String toString() {
    return 'FinishJob{'
        'unitGroupName: $unitGroupName}';
  }
}
