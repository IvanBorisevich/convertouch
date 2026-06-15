import 'package:convertouch/domain/model/job_model.dart';

class InputJobStopModel {
  final JobModel job;
  final bool stopOnError;
  final bool forceStop;

  const InputJobStopModel({
    required this.job,
    this.stopOnError = false,
    this.forceStop = false,
  });
}
