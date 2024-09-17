import 'package:convertouch/domain/constants/constants.dart';
import 'package:convertouch/domain/model/job_model.dart';

class InputCronChangeModel {
  final JobModel job;
  final Cron newCron;

  const InputCronChangeModel({
    required this.job,
    required this.newCron,
  });
}