import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/refreshing_job_model.dart';

class InputCronChangeModel {
  final RefreshingJobModel job;
  final Cron newCron;

  const InputCronChangeModel({
    required this.job,
    required this.newCron,
  });
}