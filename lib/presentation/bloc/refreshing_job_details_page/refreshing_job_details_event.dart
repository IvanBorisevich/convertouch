import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';
import 'package:convertouch/presentation/bloc/abstract_event.dart';

abstract class RefreshingJobDetailsEvent extends ConvertouchEvent {
  final RefreshingJobModel job;

  const RefreshingJobDetailsEvent({
    required this.job,
  });

  @override
  List<Object?> get props => [
        job,
      ];
}

class OpenJobDetails extends RefreshingJobDetailsEvent {
  const OpenJobDetails({
    required super.job,
  });

  @override
  String toString() {
    return 'OpenJobDetails{job: $job}';
  }
}

class SelectJobCron extends RefreshingJobDetailsEvent {
  final Cron newCron;

  const SelectJobCron({
    required this.newCron,
    required super.job,
  });

  @override
  List<Object?> get props => [
        newCron,
        super.props,
      ];

  @override
  String toString() {
    return 'SelectJobCron{newCron: $newCron}';
  }
}
