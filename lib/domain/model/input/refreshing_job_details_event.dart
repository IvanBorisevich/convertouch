import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/input/abstract_event.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';

abstract class RefreshingJobDetailsEvent extends ConvertouchEvent {
  final RefreshingJobModel job;
  final Stream<double>? progressValue;

  const RefreshingJobDetailsEvent({
    required this.job,
    required this.progressValue,
  });

  @override
  List<Object?> get props => [
    job,
    progressValue,
  ];
}

class OpenJobDetails extends RefreshingJobDetailsEvent {
  const OpenJobDetails({
    required super.job,
    required super.progressValue,
  });

  @override
  String toString() {
    return 'OpenJobDetails{job: $job}';
  }
}

class ToggleAutoRefreshMode extends RefreshingJobDetailsEvent {
  final JobAutoRefresh mode;

  const ToggleAutoRefreshMode({
    required this.mode,
    required super.job,
    required super.progressValue,
  });

  @override
  List<Object?> get props => [
    mode,
    super.props,
  ];

  @override
  String toString() {
    return 'ToggleAutoRefreshMode{'
        'mode: $mode, '
        'job: $job}';
  }
}

class SelectAutoRefreshCron extends RefreshingJobDetailsEvent {
  final Cron newCron;

  const SelectAutoRefreshCron({
    required this.newCron,
    required super.job,
    required super.progressValue,
  });

  @override
  List<Object?> get props => [
    newCron,
    super.props,
  ];

  @override
  String toString() {
    return 'SelectAutoRefreshCron{newCron: $newCron}';
  }
}

class SelectDataSource extends RefreshingJobDetailsEvent {
  const SelectDataSource({
    required super.job,
    required super.progressValue,
  });

  @override
  String toString() {
    return 'SelectDataSource{job: $job}';
  }
}